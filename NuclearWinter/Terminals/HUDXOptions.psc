ScriptName NuclearWinter:Terminals:HUDXOptions extends Terminal
import Shared:Log

UserLog Log

CustomEvent OnXChanged

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
    If (auiMenuItemID == 1)
		TemperatureWidget.X = 10
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 2)
		TemperatureWidget.X = 128
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 3)
		TemperatureWidget.X = 256
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 4)
		TemperatureWidget.X = 384
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 5)
		TemperatureWidget.X = 512
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 6)
		TemperatureWidget.X = 640
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 7)
		TemperatureWidget.X = 768
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 8)
		TemperatureWidget.X = 896
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 9)
		TemperatureWidget.X = 1024
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 10)
		TemperatureWidget.X = 1115
		SendCustomEvent("OnXChanged")
	ElseIf (auiMenuItemID == 11)
		TemperatureWidget.X = 1270
		SendCustomEvent("OnXChanged")
    EndIf
	Debug.Notification("Temperature Widget | X: " + TemperatureWidget.X + " | Y: " + TemperatureWidget.Y)
	
EndEvent

Function SetX(int value)
	TemperatureWidget.X = value
	SendCustomEvent("OnXChanged")
	Debug.Notification("Temperature Widget | X: " + TemperatureWidget.X + " | Y: " + TemperatureWidget.Y)
EndFunction


; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Context Property Context Auto Const Mandatory
	NuclearWinter:GUI:TemperatureWidget Property TemperatureWidget Auto Const Mandatory
EndGroup
