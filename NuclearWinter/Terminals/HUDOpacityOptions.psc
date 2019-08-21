ScriptName NuclearWinter:Terminals:HUDOpacityOptions extends Terminal
import Shared:Log

UserLog Log

CustomEvent OnOpacityChanged

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
    If (auiMenuItemID == 1)
		TemperatureWidget.OpacityVal = 0.2
		SendCustomEvent("OnOpacityChanged")
	ElseIf (auiMenuItemID == 2)
		TemperatureWidget.OpacityVal = 0.3
		SendCustomEvent("OnOpacityChanged")
	ElseIf (auiMenuItemID == 3)
		TemperatureWidget.OpacityVal = 0.4
		SendCustomEvent("OnOpacityChanged")
	ElseIf (auiMenuItemID == 4)
		TemperatureWidget.OpacityVal = 0.5
		SendCustomEvent("OnOpacityChanged")
	ElseIf (auiMenuItemID == 5)
		TemperatureWidget.OpacityVal = 0.6
		SendCustomEvent("OnOpacityChanged")
	ElseIf (auiMenuItemID == 6)
		TemperatureWidget.OpacityVal = 0.7
		SendCustomEvent("OnOpacityChanged")
	ElseIf (auiMenuItemID == 7)
		TemperatureWidget.OpacityVal = 0.8
		SendCustomEvent("OnOpacityChanged")
	ElseIf (auiMenuItemID == 8)
		TemperatureWidget.OpacityVal = 0.9
		SendCustomEvent("OnOpacityChanged")
	ElseIf (auiMenuItemID == 9)
		TemperatureWidget.OpacityVal = 1.0
		SendCustomEvent("OnOpacityChanged")
    EndIf
	Debug.Notification("Temperature Widget | Opacity: " + TemperatureWidget.OpacityVal)
	
EndEvent

Function SetOpacity(float value)
	TemperatureWidget.OpacityVal = value
	SendCustomEvent("OnOpacityChanged")
	Debug.Notification("Temperature Widget | Opacity: " + TemperatureWidget.OpacityVal)
EndFunction


; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Context Property Context Auto Const Mandatory
	NuclearWinter:GUI:TemperatureWidget Property TemperatureWidget Auto Const Mandatory
EndGroup
