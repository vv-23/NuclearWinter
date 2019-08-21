ScriptName NuclearWinter:ContextActivation extends NuclearWinter:Core:Required
import Shared:Log
import NuclearWinter
import NuclearWinter:Context

UserLog Log

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent

Function SetActivation()
	If Context.IsActivated == false
		Context.IsActivated = true
		WriteLine(Log, "Attempting to start the '"+Context.Title+"' context.")
	ElseIf Context.IsActivated == true
		Context.IsActivated = false
		WriteLine(Log, "Attempting to shutdown the '"+Context.Title+"' context.")
	EndIf
EndFunction
