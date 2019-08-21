Scriptname NuclearWinter:World:Shader extends NuclearWinter:Core:Optional
{QUST:Winter_Context}
import NuclearWinter
import Shared:Log

UserLog Log
EffectShader FXS
bool Effect


; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Shader"
	VFX = None
EndEvent


Event OnEnable()
	RegisterForCustomEvent(Climate, "OnWeatherChanged")
	RegisterForCustomEvent(Thermodynamics, "OnChanged")
	Effect = false
	GoToState("ActiveState")
EndEvent


Event OnDisable()
	UnregisterForCustomEvent(Climate, "OnWeatherChanged")
	UnRegisterForCustomEvent(Thermodynamics, "OnChanged")
	GoToState("")
EndEvent


; Methods
;---------------------------------------------

State ActiveState

	Event OnEndState(string asNewState)
		Stop()
		Effect = false
		WriteLine(Log, "Removed FXS for end of state.")
	EndEvent
	
	Event NuclearWinter:World:Thermodynamics.OnChanged(World:Thermodynamics akSender, var[] arguments)
		If Thermodynamics.Temperature <= -5.0 && Effect == false
			Effect = true
			Start()
		ElseIf Thermodynamics.Temperature > -5.0 && Effect == true
			Effect = false
			Stop()
		EndIf
	EndEvent


	Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		If (ConditionDatabase.GetEffectShader(Climate.CurrentWeather) != None)
			If (ConditionDatabase.GetEffectShader(Climate.CurrentWeather) != FXS)
				Stop()
				FXS = ConditionDatabase.GetEffectShader(Climate.CurrentWeather)
				WriteLine(Log, "New Effect: " + FXS)
			EndIf
		EndIf
	EndEvent
EndState


Event NuclearWinter:World:Thermodynamics.OnChanged(World:Thermodynamics akSender, var[] arguments)
	{EMPTY}
EndEvent


Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent


; Properties
;---------------------------------------------
Function Start()
	If (FXS != None)
		FXS.Play(Player)
		WriteLine(Log, "Start Effect: " + FXS)
	EndIf
EndFunction


Function Stop()
	If (FXS != None)
		FXS.Stop(Player)
		WriteLine(Log, "Stop Effect:" + FXS)
	EndIf
EndFunction


; Properties
;---------------------------------------------

Group Context
	World:Climate Property Climate Auto Const Mandatory
	World:Thermodynamics Property Thermodynamics Auto Const Mandatory
	World:WeatherDatabase Property WeatherDatabase Auto Const Mandatory
EndGroup


