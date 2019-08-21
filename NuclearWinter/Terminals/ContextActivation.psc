ScriptName NuclearWinter:Terminals:ContextActivation extends Terminal
import Shared:Log
import NuclearWinter

UserLog Log

int ReturnID = 2 const
int OptionStartup = 1 const
int OptionShutdown = 3 const


; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
	If (auiMenuItemID == ReturnID)
		return

    ElseIf (auiMenuItemID == OptionStartup)
		WriteLine(Log, "Attempting to start the '"+Context.Title+"' context.")
		Context.IsActivated = true

	ElseIf(auiMenuItemID == OptionShutdown)
		WriteLine(Log, "Attempting to shutdown the '"+Context.Title+"' context.")
		Context.IsActivated = false
	Else
		WriteLine(Log, "Unhandled menu item with '"+auiMenuItemID+"' ID.")
    EndIf
EndEvent

Function SetActivation(bool value)
	If value == true
		Context.IsActivated = true
		WriteLine(Log, "Attempting to start the '"+Context.Title+"' context.")
	ElseIf value == false
		Context.IsActivated = false
		WriteLine(Log, "Attempting to shutdown the '"+Context.Title+"' context.")
	EndIf
EndFunction


; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Context Property Context Auto Const Mandatory
EndGroup
