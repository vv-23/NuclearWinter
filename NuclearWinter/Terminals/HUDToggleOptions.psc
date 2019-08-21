ScriptName NuclearWinter:Terminals:HUDToggleOptions extends Terminal
import Shared:Log

UserLog Log

CustomEvent OnToggleChanged

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
    If (auiMenuItemID == 4)
		SendCustomEvent("OnToggleChanged")
    EndIf
EndEvent

Function SetHUDToggle(bool value)
	SendCustomEvent("OnToggleChanged")
EndFunction


; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Context Property Context Auto Const Mandatory
	NuclearWinter:GUI:TemperatureWidget Property TemperatureWidget Auto Const Mandatory
EndGroup
