Scriptname NuclearWinter:World:Thermodynamics extends NuclearWinter:Core:Optional
{QUST:NuclearWinter_World}
import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log
Data Current
CustomEvent OnChanged
CustomEvent OnThreshold

bool first = true

float UpdateInterval
float InWeatherPerc
float OutWeatherPerc

int UpdateTimer = 0 const
int CalcTimer = 1 const
int SFXTimer = 2 const

var[] params


; Events
;==========================================================================================

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Heat"
	Current = new Data
EndEvent


Event OnEnable()
	RegisterForCustomEvent(Equipment, "OnChanged")
	RegisterForCustomEvent(Climate, "OnWeatherTransition")
	RegisterForCustomEvent(Climate, "OnWeatherChanged")
	RegisterForCustomEvent(Climate, "OnLocationChanged")
EndEvent


Event OnDisable()
	UnregisterForCustomEvent(Equipment, "OnChanged")
	UnregisterForCustomEvent(Climate, "OnWeatherTransition")
	UnregisterForCustomEvent(Climate, "OnWeatherChanged")
	UnregisterForCustomEvent(Climate, "OnLocationChanged")
EndEvent

; Radiation Events/Functions
;==========================================================================================
State ActiveState
	Event OnBeginState(string asOldState)
		WriteLine(Log, "Beginning the ActiveState from the '"+asOldState+"'.")
		Current = new Data
	EndEvent

	;Events for Starting Radiation
	;----------------------------------------------------------

	Event NuclearWinter:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
		WriteLine(Log, "Radiation: OnLocationChanged")

	EndEvent

	Event NuclearWinter:Gear:Equipment.OnChanged(Gear:Equipment akSender, var[] arguments)
		WriteLine(Log, "Radiation: Equipment.OnChanged")
		
	EndEvent

	Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		WriteLine(Log, "Radiation: OnWeatherChanged")
		
	EndEvent


	;Check for Temperature
	;----------------------------------------------------------
	Function CheckTemperature()
		WriteLine(Log, "CheckTemperature()")
		
	EndFunction
	;----------------------------------------------------------

EndState

State RadiationONState

	Event OnBeginState(string asOldState)
		WriteLine(Log, "Beginning the RadiationOnState from the '"+asOldState+"'.")
		Current = new Data
		StartTimer(2,CalcTimer)
	EndEvent

	;Events for Removing Radiation
	;----------------------------------------------------------

	Event NuclearWinter:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
		WriteLine(Log, "Handling Climate.OnLocationChanged")
		If (Player.IsInInterior())
			WriteLine(Log, "Player Inside, removing Radiation")
			Dispel_Rad()
		EndIf
	EndEvent


	Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		WriteLine(Log, "Temp_Change: OnWeatherChanged")
		
	EndEvent

	Event NuclearWinter:Gear:Equipment.OnChanged(Gear:Equipment akSender, var[] arguments)
		Utility.wait(0.2)
		
	EndEvent

	Event ObjectReference.OnItemAdded(ObjectReference akreference,Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
		Utility.wait(0.2)
		WriteLine(Log, "OnItemAdded "+akItemReference)
		If (Filter.Charge > 0 && Equipment.IsGasEquipment)
			Dispel_Rad()
		EndIf
	EndEvent


	;Calculate Temp_Change
	;----------------------------------------------------------
	Event NuclearWinter:World:Climate.OnWeatherTransition(World:Climate akSender, var[] arguments)
		;Acquiring Target Temp_Change
		CalcTemp_Change()
	EndEvent
	;-----------------------------------------------------------------

EndState

Function CalcTemperatureChange()

EndFunction

Function CalcCoreTempChange()
	
EndFunction

;Apply Temp_Change
;-----------------------------------------------------------------
Event OnTimer(int aiTimerID)
	;WriteLine(Log, "PollTemp_Change()")

		if(aiTimerID == UpdateTimer)
		
		EndIf

		If(aiTimerID == CalcTimer)
			WriteLine(Log, "Calculating Target")
			CalcTemperatureChange()
			StartTimer(10,CalcTimer)
		EndIf
		
		If(aiTimerID == SFXTimer)
			isPastThreshold = Threshold
			WriteLine(Log, "Temp_Change: OnChanged | Timer | Threshold = "+Threshold)
			SendCustomEvent("OnChanged")
			StartTimer(16, SFXTimer)
		EndIf
EndEvent

Event NuclearWinter:Terminals:WorldRadiationMode.OnChanged(Terminals:WorldRadiationMode akSender, var[] arguments)
	CalcTemperatureChange()
EndEvent
;-----------------------------------------------------------------

int Function GetMultiplier(int aiWeatherClass, bool abInWeather = true)
	If (aiWeatherClass == Climate.WeatherClassNone)
		return 0
	ElseIf (aiWeatherClass == Climate.WeatherClassPleasant)
		If (abInWeather)
			return InMultiplierA
		EndIf
	ElseIf (aiWeatherClass == Climate.WeatherClassCloudy)
		If (abInWeather)
			return InMultiplierB
		EndIf
	ElseIf (aiWeatherClass == Climate.WeatherClassRainy)
		If (abInWeather)
			return InMultiplierC
		EndIf
	ElseIf (aiWeatherClass == Climate.WeatherClassSnow)
		If (abInWeather)
			return InMultiplierD
		EndIf
	Else
		; unknown weather class
		return 0
	EndIf
EndFunction

;Empty Functions/Events
;---------------------------------------------

Event NuclearWinter:World:Climate.OnWeatherTransition(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent

Function CheckTemperature()
	{EMPTY}
EndFunction

Event NuclearWinter:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:Gear:Equipment.OnChanged(Gear:Equipment akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent


; Properties
;---------------------------------------------

Group Context
	Gear:Equipment Property Equipment Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory
EndGroup

Group Properties
	GlobalVariable Property Winter_AmbientTemp Auto 
	GlobalVariable Property Winter_Difficulty Auto
EndGroup


Group Temp_Change
	float Property Exposure Hidden
		float Function Get()
			return Current.Exposure
		EndFunction
		Function Set(float value)
			Current.Exposure += value
		EndFunction
	EndProperty

	bool Property Threshold Hidden
		bool Function Get()
			return (Current.Target >= 17.0)
		EndFunction
	EndProperty
	
	bool Property isPastThreshold Auto Hidden
		
	bool Property IsRadioactive Hidden
		bool Function Get()
			If NoTemp_Change == false
				If (Player.IsInInterior() == false && Player.IsInFaction(ChildrenOfAtomFaction) == false && Player.WornHasKeyword(ArmorTypePower) == false && Player.HasMagicEffect(GasEquipment_AirFilter_SpellEffect) == false && ( Equipment.IsGasEquipment == false || ((Filter.Available == false && Filter.HasCharge == false) || Filter.HasCharge == false) ) )
					return true
				Else
					return false
				EndIf
			EndIf
		EndFunction
	EndProperty

	int Property InMultiplierA = 7 AutoReadOnly
	int Property InMultiplierB = 17 AutoReadOnly
	int Property InMultiplierC = 29 AutoReadOnly
	int Property InMultiplierD = 61 AutoReadOnly
	
	Keyword Property ArmorTypePower Auto Const Mandatory

EndGroup


Group Settings
	bool Property WeatherOnly = false Auto
	bool Property RadWeatherOnly = false Auto
	bool property NoTemp_Change = false Auto
EndGroup
