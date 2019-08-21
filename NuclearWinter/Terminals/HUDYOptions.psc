ScriptName NuclearWinter:Terminals:HUDYOptions extends Terminal
import Shared:Log

UserLog Log

CustomEvent OnYChanged

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
    If (auiMenuItemID == 1)
		TemperatureWidget.Y = 10
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 2)
		TemperatureWidget.Y = 72
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 3)
		TemperatureWidget.Y = 144
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 4)
		TemperatureWidget.Y = 216
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 5)
		TemperatureWidget.Y = 288
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 6)
		TemperatureWidget.Y = 360
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 7)
		TemperatureWidget.Y = 432
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 8)
		TemperatureWidget.Y = 504
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 9)
		TemperatureWidget.Y = 576
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 10)
		TemperatureWidget.Y = 648
		SendCustomEvent("OnYChanged")
	ElseIf (auiMenuItemID == 11)
		TemperatureWidget.Y = 710
		SendCustomEvent("OnYChanged")
    EndIf
	Debug.Notification("Temperature Widget | X: " + TemperatureWidget.X + " | Y: " + TemperatureWidget.Y)
	
EndEvent

Function SetY(int value)
	TemperatureWidget.Y = value
	SendCustomEvent("OnYChanged")
	Debug.Notification("Temperature Widget | X: " + TemperatureWidget.X + " | Y: " + TemperatureWidget.Y)
EndFunction


; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Context Property Context Auto Const Mandatory
	NuclearWinter:GUI:TemperatureWidget Property TemperatureWidget Auto Const Mandatory
EndGroup
