ScriptName NuclearWinter:Terminals:HUDScaleXOptions extends Terminal
import Shared:Log

UserLog Log

CustomEvent OnScaleXChanged

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
    If (auiMenuItemID == 1)
		TemperatureWidget.ScaleX = 0.2
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 2)
		TemperatureWidget.ScaleX = 0.3
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 3)
		TemperatureWidget.ScaleX = 0.4
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 4)
		TemperatureWidget.ScaleX = 0.5
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 5)
		TemperatureWidget.ScaleX = 0.6
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 6)
		TemperatureWidget.ScaleX = 0.7
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 7)
		TemperatureWidget.ScaleX = 0.8
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 8)
		TemperatureWidget.ScaleX = 0.9
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 9)
		TemperatureWidget.ScaleX = 1.0
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 10)
		TemperatureWidget.ScaleX = 1.1
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 11)
		TemperatureWidget.ScaleX = 1.2
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 14)
		TemperatureWidget.ScaleX = 1.3
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 15)
		TemperatureWidget.ScaleX = 1.4
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 16)
		TemperatureWidget.ScaleX = 1.5
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 17)
		TemperatureWidget.ScaleX = 1.6
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 18)
		TemperatureWidget.ScaleX = 1.7
		SendCustomEvent("OnScaleXChanged")	
	ElseIf (auiMenuItemID == 19)
		TemperatureWidget.ScaleX = 1.8
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 20)
		TemperatureWidget.ScaleX = 1.9
		SendCustomEvent("OnScaleXChanged")
	ElseIf (auiMenuItemID == 21)
		TemperatureWidget.ScaleX = 2.0
		SendCustomEvent("OnScaleXChanged")
    EndIf
	Debug.Notification("Temperature Widget | ScaleX: " + TemperatureWidget.ScaleX + " | ScaleY: " + TemperatureWidget.ScaleY)
	
EndEvent

Function SetX(float value)
	TemperatureWidget.ScaleX = value
	SendCustomEvent("OnScaleXChanged")
	Debug.Notification("Temperature Widget | ScaleX: " + TemperatureWidget.ScaleX + " | ScaleY: " + TemperatureWidget.ScaleY)
EndFunction


; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Context Property Context Auto Const Mandatory
	NuclearWinter:GUI:TemperatureWidget Property TemperatureWidget Auto Const Mandatory
EndGroup
