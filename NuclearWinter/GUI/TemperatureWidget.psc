Scriptname NuclearWinter:GUI:TemperatureWidget extends NuclearWinter:GUI:HUDWidget
{QUST:Winter_Context}
import NuclearWinter
import NuclearWinter:Context
import Shared:Log
import Math


UserLog Log
Actor Player

int Command_UpdateTemp = 100 const
int Command_UpdateWetness = 200 const
int Command_UpdateHeat = 300 const


; Events
;---------------------------------------------

Event OnInitialize()
	Log = GetLog(self)
	Log.FileName = "Winter_TemperatureWidget"
	Player = Game.GetPlayer()
EndEvent


Event OnEnable()
	If (NuclearWinter:GUI:HUDWidget.WidgetRegister(HUD_Public, Widget_Public, self))
		WriteLine(Log, "Something went right.")
	Else
		WriteLine(Log, "Something went wrong.")
	EndIf
	SetHUDToggle(true)
	RegisterForRemoteEvent(Player,"OnPlayerLoadGame")
	RegisterForCustomEvent(Thermodynamics, "OnChanged")
	float[] afArguments = new float[3]
	afArguments[0] = 1.0	
	SendNumber(Command_UpdateWetness, afArguments)
	afArguments[0] = 1.0
	SendNumber(Command_UpdateHeat, afArguments)
	Utility.Wait(1.0)
	afArguments[0] = 1.0	
	SendNumber(Command_UpdateWetness, afArguments)
EndEvent


Event OnDisable()
	SetHUDToggle(false)
	UnRegisterForRemoteEvent(Player,"OnPlayerLoadGame")
	UnRegisterForCustomEvent(Thermodynamics, "OnChanged")
EndEvent

Event Actor.OnPlayerLoadGame(Actor akActor)
	If (NuclearWinter:GUI:HUDWidget.WidgetRegister(HUD_Public, Widget_Public, self))
		WriteLine(Log, "Something went right.")
	Else
		WriteLine(Log, "Something went wrong.")
	EndIf
	Utility.Wait(1.0)
	TryLoad()
	float[] afArguments = new float[3]
	afArguments[0] = 1.0	
	SendNumber(Command_UpdateWetness, afArguments)
	afArguments[0] = 1.0
	SendNumber(Command_UpdateHeat, afArguments)
	Utility.Wait(1.0)
	afArguments[0] = 1.0	
	SendNumber(Command_UpdateWetness, afArguments)
EndEvent

Event OnWidgetLoaded()
	Update()
EndEvent

Event NuclearWinter:World:Thermodynamics.OnChanged(World:Thermodynamics akSender, var[] arguments)
	Update()
	WriteLine(Log, "Updated widget for the Temperature Change event.")
EndEvent


; Functions
;---------------------------------------------


Function SetWidgetParameters()
	Utility.wait(0.2)
	SetOpacityModify(OpacityVal)
	SetScaleModify(ScaleX, ScaleY)
	SetPositionModify(X, Y)
EndFunction

;Opcaity ---------------------
Function SetOpacity(float value)
	Utility.wait(0.2)
	OpacityVal = value
	SetOpacityModify(OpacityVal)
EndFunction

;Scale ------------------------
Function SetXScale(float value)
	Utility.wait(0.2)
	ScaleX = value
	SetScaleModify(ScaleX, ScaleY)
EndFunction

Function SetYScale(float value)
	Utility.wait(0.2)
	ScaleY = value
	SetScaleModify(ScaleX, ScaleY)
EndFunction
;Position ----------------------
Function SetXPos(int value)
	Utility.wait(0.2)
	X = value
	SetPositionModify(X, Y)
EndFunction

Function SetYPos(int value)
	Utility.wait(0.2)
	Y = value
	SetPositionModify(X, Y)
EndFunction

Function SetHUDToggle(bool value)
	Utility.wait(0.2)
	HUDToggle = value
	If HUDToggle
		If(TryLoad())
			WriteLine(Log, "Loaded widget.")
		EndIf
	ElseIf HUDToggle == false
		If(Unload())
			WriteLine(Log, "Unloaded widget.")
		EndIf
	EndIf
	Winter_TempWidgetToggle.SetValue(HUDToggle as float)
	Debug.Notification("Temperature Widget | HUD Toggle: " + HUDToggle)
EndFunction

WidgetData Function Create()
	WidgetData widget = new WidgetData
	widget.ID = "TemperatureWidget.swf"
	widget.X = X
	widget.Y = Y
	return widget
EndFunction


; Functions
;---------------------------------------------

bool Function TryLoad()
	If(HUDToggle)
		If (Load())
			Update()
			return true
		Else
			WriteLine(Log, "Could not try to load the widget.")
			return false
		EndIf
	Else
		WriteLine(Log, "Could not load the widget, it is toggled off.")
		return false
	EndIf
EndFunction


Function Update()
	float[] afArguments = new float[3]
	; Check to see if the player prefers Celcius (1 = C, 0 = F)
	If Winter_TemperatureScale.GetValue() == 1.0
		afArguments[0] = (Thermodynamics.Temperature - 32) / 1.8
	Else
		afArguments[0] = Thermodynamics.Temperature
	EndIf
	
	
	;Check to see if the player prefers MPH or KPH (1 = KPH, 0 = MPH)
	If Winter_WindScale.GetValue() == 0.0
		afArguments[1] = Thermodynamics.WindSpeed
	Else
		afArguments[1] = Thermodynamics.WindSpeed * 1.609344
	EndIf
	; Check to see if the player prefers Celcius (1 = C, 0 = F)
	If Winter_TemperatureScale.GetValue() == 1.0
		afArguments[2] = (Thermodynamics.CoreTemperature - 32) / 1.8
	Else
		afArguments[2] = Thermodynamics.CoreTemperature
	EndIf
	; Wetness: 1.0 = 0	1.7 = 100
	SendNumber(Command_UpdateTemp, afArguments)
	afArguments[0] = Floor((Thermodynamics.Wetness - 1.0) * 100 / 0.7)	
	SendNumber(Command_UpdateWetness, afArguments)
	If (HeatSource.IsInHeatSource)
		afArguments[0] = 1.0
		SendNumber(Command_UpdateHeat, afArguments)
	Else
		afArguments[0] = 0.0
		SendNumber(Command_UpdateHeat, afArguments)
	EndIf
EndFunction


; Properties
;---------------------------------------------

Group Context
	World:Thermodynamics Property Thermodynamics  Auto Const Mandatory
	World:HeatSource Property HeatSource Auto Const Mandatory
EndGroup

Group Properties
	GlobalVariable Property Winter_WindScale Auto
	GlobalVariable Property Winter_TemperatureScale Auto
	GlobalVariable Property Winter_TempWidgetToggle Auto
	float property OpacityVal = 1.0 Auto 
	float property ScaleX = 1.0 Auto
	float property ScaleY = 1.0 Auto
	int property X = 10 Auto
	int property Y = 10 Auto
	bool property HUDToggle Auto 
EndGroup
