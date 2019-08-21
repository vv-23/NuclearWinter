ScriptName NuclearWinter:Terminals:GearMaskFilterReplace extends Terminal
import NuclearWinter
import Shared:Log

UserLog Log

int ReturnID = 1 const
int Filter1ID = 2 const
int Filter2ID = 3 const
int FastFilter1ID = 4 const
int FastFilter2ID = 5 const


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
	ElseIf (auiMenuItemID == Filter1ID)
		FilterReplace.NuclearWinter_GearFilterReplaceSFX = GasMask_GearFilterReplace1SFX
	ElseIf (auiMenuItemID == Filter2ID)
		FilterReplace.NuclearWinter_GearFilterReplaceSFX = GasMask_GearFilterReplace2SFX
	ElseIf (auiMenuItemID == FastFilter1ID)
		FilterReplace.NuclearWinter_GearFilterFastReplaceSFX = GasMask_GearFilterReplaceFast1SFX
	ElseIf (auiMenuItemID == FastFilter2ID)
		FilterReplace.NuclearWinter_GearFilterFastReplaceSFX = GasMask_GearFilterReplaceFast2SFX
	EndIf
EndEvent


; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Context Property Context Auto Const Mandatory
	Gear:FilterReplace Property FilterReplace Auto Const Mandatory
EndGroup


Group Properties
	Sound Property GasMask_GearFilterReplace1SFX Auto Const Mandatory
	Sound Property GasMask_GearFilterReplace2SFX Auto Const Mandatory
	Sound Property GasMask_GearFilterReplaceFast1SFX Auto Const Mandatory
	Sound Property GasMask_GearFilterReplaceFast2SFX Auto Const Mandatory
EndGroup
