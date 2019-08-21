ScriptName NuclearWinter:Terminals:GearMaskLowFilterIMODPreset extends Terminal
import NuclearWinter
import Shared:Log

UserLog Log

int ReturnID = 1 const
int Stage1 = 2 const
int Stage2 = 3 const
int NoGlass = 4 const


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
	ElseIf (auiMenuItemID == Stage1)
		MaskBreathing.NuclearWinter_ChoughingScreenFX = GasMask_CoughingScreenFX
	ElseIf (auiMenuItemID == Stage2)
		MaskBreathing.NuclearWinter_ChoughingScreenFX = GasMask_CoughingScreen_NoFadeFX
	ElseIf (auiMenuItemID == NoGlass)
		MaskBreathing.NuclearWinter_ChoughingScreenFX = NoEffect
	EndIf
EndEvent


; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Context Property Context Auto Const Mandatory
	Gear:MaskBreathing Property MaskBreathing Auto Const Mandatory
EndGroup


Group Properties
	ImageSpaceModifier Property GasMask_CoughingScreen_NoFadeFX Auto Const Mandatory
	ImageSpaceModifier Property GasMask_CoughingScreenFX Auto Const Mandatory
	ImageSpaceModifier Property NoEffect Auto Const
EndGroup
