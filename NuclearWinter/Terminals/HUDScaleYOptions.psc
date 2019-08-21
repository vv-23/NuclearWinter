ScriptName NuclearWinter:Terminals:HUDScaleYOptions extends Terminal
import Shared:Log

UserLog Log

CustomEvent OnScaleYChanged

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
    If (auiMenuItemID == 1)
		TemperatureWidget.ScaleY = 0.2
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 2)
		TemperatureWidget.ScaleY = 0.3
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 3)
		TemperatureWidget.ScaleY = 0.4
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 4)
		TemperatureWidget.ScaleY = 0.5
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 5)
		TemperatureWidget.ScaleY = 0.6
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 6)
		TemperatureWidget.ScaleY = 0.7
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 7)
		TemperatureWidget.ScaleY = 0.8
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 8)
		TemperatureWidget.ScaleY = 0.9
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 9)
		TemperatureWidget.ScaleY = 1.0
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 10)
		TemperatureWidget.ScaleY = 1.1
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 11)
		TemperatureWidget.ScaleY = 1.2
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 14)
		TemperatureWidget.ScaleY = 1.3
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 15)
		TemperatureWidget.ScaleY = 1.4
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 16)
		TemperatureWidget.ScaleY = 1.5
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 17)
		TemperatureWidget.ScaleY = 1.6
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 18)
		TemperatureWidget.ScaleY = 1.7
		SendCustomEvent("OnScaleYChanged")	
	ElseIf (auiMenuItemID == 19)
		TemperatureWidget.ScaleY = 1.8
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 20)
		TemperatureWidget.ScaleY = 1.9
		SendCustomEvent("OnScaleYChanged")
	ElseIf (auiMenuItemID == 21)
		TemperatureWidget.ScaleY = 2.0
		SendCustomEvent("OnScaleYChanged")
    EndIf
	Debug.Notification("Temperature Widget | ScaleX: " + TemperatureWidget.ScaleX + " | ScaleY: " + TemperatureWidget.ScaleY)
	
EndEvent

Function SetY(float value)
	TemperatureWidget.ScaleY = value
	SendCustomEvent("OnScaleYChanged")
	Debug.Notification("Temperature Widget | ScaleX: " + TemperatureWidget.ScaleX + " | ScaleY: " + TemperatureWidget.ScaleY)
EndFunction


; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Context Property Context Auto Const Mandatory
	NuclearWinter:GUI:TemperatureWidget Property TemperatureWidget Auto Const Mandatory
EndGroup
