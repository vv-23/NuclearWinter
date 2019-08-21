Scriptname NuclearWinter:World:ClimateReader extends NuclearWinter:Core:Optional
{QUST:NuclearWinter_World}
import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "ClimateReader"
EndEvent

Event OnEnable()
	RegisterForRemoteEvent(Player, "OnLocationChange")
	RegisterForCustomEvent(Climate, "OnWeatherChanged")
	RegisterForCustomEvent(WorldWeatherWarningToggle, "OnChanged")
	WriteLine(Log, "ClimateReader finished Enabling...")
EndEvent


Event OnDisable()
	UnregisterForRemoteEvent(Player, "OnLocationChange")
	UnRegisterForCustomEvent(Climate, "OnWeatherChanged")
	UnRegisterForCustomEvent(WorldWeatherWarningToggle, "OnChanged")
	WriteLine(Log, "ClimateReader finished Disabling...")
	GoToState(" ")
EndEvent

int UpdateTimer = 1

; Events ------------------------------------------------------------------------

State ActiveState

	Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
			WriteLine(Log, "ClimateReader: OnWeatherChanged")
			Evaluate()
	EndEvent

	;Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
		;WriteLine(Log, "ClimateReader: OnLocationChanged")
		;If (akOldLoc.IsInterior() && Player.IsInInterior() == false)
			;Evaluate()
		;Endif
	;EndEvent

EndState

Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent

Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
	{EMPTY}
EndEvent

Event NuclearWinter:Terminals:WorldWeatherWarningToggle.OnChanged(Terminals:WorldWeatherWarningToggle akSender, var[] arguments)
	If(ClimateReaderOn)
		GoToState("ActiveState")
	Else
		GoToState(" ")
	EndIf
EndEvent
	
; Functions ---------------------------------------------------------------------

Function Evaluate()
	If(Radiation.NoRadiation == false)
		If((Climate.WeatherBad && Radiation.WeatherOnly) || (Radiation.WeatherOnly == false && Radiation.RadWeatherOnly == false) || (Climate.RadWeatherBad && Radiation.RadWeatherOnly))
			WriteLine(Log, "Warning Player of dangerous weather...")
			If MessageOn == true
				WeatherWarning.Show()
			EndIf
			If SFXOn == true
				WeatherWarningSFX.Play(Player)
				Utility.wait(2.0)
				WeatherWarningSFX.Play(Player)
			EndIf
		EndIf
	EndIf
EndFunction

; Properties --------------------------------------------------------------------

Group Context
	Gear:Mask Property Mask Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory
	World:Radiation Property Radiation Auto Const Mandatory
	Terminals:WorldWeatherWarningToggle Property WorldWeatherWarningToggle Auto Const Mandatory
EndGroup

Group Properties
	Keyword Property LocTypeClearable Auto Const Mandatory
	Keyword Property LocTypeDungeon Auto Const Mandatory
	Sound Property WeatherWarningSFX Auto Const Mandatory
	Message Property WeatherWarning Auto Const mandatory
	bool Property ClimateReaderOn Auto
	bool Property SFXOn Auto
	bool Property MessageOn Auto
EndGroup
