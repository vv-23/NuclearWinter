ScriptName NuclearWinter:Terminals:GearFilterAutoReplaceMode extends Terminal
import Shared:Log
import NuclearWinter

UserLog Log

int OptionAutoReplace = 2 const
int OptionManualReplace = 3 const


; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
    If (auiMenuItemID == OptionAutoReplace)
		Filter.AutoReplace = true
		WriteLine(Log, "Auto Replace Activated")
	ElseIf(auiMenuItemID == OptionManualReplace)
		Filter.AutoReplace = false
		WriteLine(Log, "Manual Activated")
    EndIf
EndEvent


; Properties
;---------------------------------------------

Group Context
	Gear:Filter Property Filter Auto Const Mandatory
	NuclearWinter:Context Property Context Auto Const Mandatory
EndGroup
