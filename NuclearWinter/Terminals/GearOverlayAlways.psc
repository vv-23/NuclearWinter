ScriptName NuclearWinter:Terminals:GearOverlayAlways extends Terminal
import Shared:Log

UserLog Log

int OverlayAlwaysOption = 2 const


; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
    If (auiMenuItemID == OverlayAlwaysOption)
		If MaskOverlay.OverlayAlways
			MaskOverlay.OverlayAlways = false
			WriteLine(Log, "OverlayAlways Disabled")
		Else
			MaskOverlay.OverlayAlways = true
			WriteLine(Log, "OverlayAlways Activated")
		EndIf
			Debug.Notification("Overlay Always Toggled")
    EndIf
	
EndEvent


; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Context Property Context Auto Const Mandatory
	NuclearWinter:Gear:MaskOverlay Property MaskOverlay Auto Const Mandatory
EndGroup
