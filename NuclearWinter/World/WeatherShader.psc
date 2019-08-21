Scriptname NuclearWinter:World:WeatherShader extends NuclearWinter:Core:Optional
{QUST:Winter_Context}
import NuclearWinter
import Shared:Log

UserLog Log
EffectShader FXS
EffectShader NextShader
bool Effect


; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_WeatherShader"
	FXS = None
EndEvent


Event OnEnable()
	Winter_ShaderToggle.SetValue(1.0)
	RegisterForCustomEvent(Climate, "OnWeatherChanged")
	RegisterForCustomEvent(Thermodynamics, "OnChanged")
	RegisterForCustomEvent(HeatSource, "OnHeatSourceIn")
	RegisterForCustomEvent(HeatSource, "OnHeatSourceOut")
	Effect = false
	GoToState("ActiveState")
EndEvent


Event OnDisable()
	Winter_ShaderToggle.SetValue(0.0)
	UnregisterForCustomEvent(Climate, "OnWeatherChanged")
	UnRegisterForCustomEvent(Thermodynamics, "OnChanged")
	UnRegisterForCustomEvent(HeatSource, "OnHeatSourceIn")
	UnRegisterForCustomEvent(HeatSource, "OnHeatSourceOut")
	Stop()
	Effect = false
	GoToState("")
EndEvent

State ActiveState

	Event OnBeginState(string asOldState)
		CheckShader()
		WriteLine(Log, "Checking FXS for beginning of state.")
	EndEvent

	Event OnEndState(string asNewState)
		Stop()
		WriteLine(Log, "Removed FXS for end of state.")
	EndEvent
	
	Event NuclearWinter:World:Thermodynamics.OnChanged(World:Thermodynamics akSender, var[] arguments)
		Evaluate()
	EndEvent

	Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		CheckShader()
		WriteLine(Log, "OnWeatherChanged Event")
	EndEvent
	
	Event NuclearWinter:World:HeatSource.OnHeatSourceIn(World:HeatSource akSender, var[] arguments)
		Evaluate()
		WriteLine(Log, "OnHeatSourceIn Event")
	EndEvent

	Event NuclearWinter:World:HeatSource.OnHeatSourceOut(World:HeatSource akSender, var[] arguments)
		Evaluate()
		WriteLine(Log, "OnHeatSourceOut Event")
	EndEvent
	
EndState


Event NuclearWinter:World:Thermodynamics.OnChanged(World:Thermodynamics akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:World:HeatSource.OnHeatSourceIn(World:HeatSource akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:World:HeatSource.OnHeatSourceOut(World:HeatSource akSender, var[] arguments)
	{EMPTY}
EndEvent

; Functions
;---------------------------------------------
Function Start()
	If (FXS != None)
		FXS.Play(Player)
		Effect = true
		WriteLine(Log, "Start Effect: " + FXS)
	EndIf
EndFunction


Function Stop()
	If (FXS != None)
		FXS.Stop(Player)
		Effect = false
		WriteLine(Log, "Stop Effect:" + FXS)
	EndIf
	FXS = NextShader
EndFunction

Function Evaluate()
	If Thermodynamics.Temperature <= 32.0 && Effect == false && HeatSource.IsInHeatSource == false
		Start()
	ElseIf (Thermodynamics.Temperature > 32.0 || HeatSource.IsInHeatSource)
		Stop()
	EndIf
EndFunction

Function CheckShader()
	If (WeatherDatabase.GetEffectShader(Climate.CurrentWeather) != None)
		If (WeatherDatabase.GetEffectShader(Climate.CurrentWeather) != FXS)
			NextShader = WeatherDatabase.GetEffectShader(Climate.CurrentWeather)
			Stop()
			Evaluate()
			WriteLine(Log, "New Effect: " + FXS)
		EndIf
	Else
		NextShader = Winter_EmptyShader
		WriteLine(Log, "New Effect: None")
	EndIf
EndFunction

Function Toggle()
	Utility.Wait(2.0)
	If (GetState() == "")
		Winter_ShaderToggle.SetValue(1.0)
		GoToState("ActiveState")
	Else
		Winter_ShaderToggle.SetValue(0.0)
		GoToState("")
	EndIf
EndFunction

; Properties
;---------------------------------------------

Group Context
	World:Climate Property Climate Auto Const Mandatory
	World:Thermodynamics Property Thermodynamics Auto Const Mandatory
	World:WeatherDatabase Property WeatherDatabase Auto Const Mandatory
	World:HeatSource Property HeatSource Auto Const Mandatory
EndGroup

Group Properties
	EffectShader Property Winter_EmptyShader Auto
	GlobalVariable Property Winter_ShaderToggle Auto
	;EffectShader Property Winter_RainShader Auto
EndGroup


