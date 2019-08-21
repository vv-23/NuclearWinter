ScriptName NuclearWinter:Terminals:GearMaskGogglesOverlayPreset extends Terminal
import NuclearWinter
import Shared:Log

UserLog Log

int ReturnID = 8 const
int OverlayID = 1 const
int Stage1 = 2 const
int Stage2 = 3 const
int Stage3 = 4 const
int Stage4 = 5 const
int Stage5 = 6 const
int Stage6 = 7 const
int NoGlass = 9 const


; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
	If (auiMenuItemID == ReturnID || auiMenuItemID == OverlayID )
		return
	ElseIf (auiMenuItemID == Stage1)
		MaskOverlay.VisualFX = GasMask_GearGogglesVisual_Stage1
	ElseIf (auiMenuItemID == Stage2)
		MaskOverlay.VisualFX = GasMask_GearGogglesVisual_Stage2
	ElseIf (auiMenuItemID == Stage3)
		MaskOverlay.VisualFX = GasMask_GearGogglesVisual_Stage3
	ElseIf (auiMenuItemID == Stage4)
		MaskOverlay.VisualFX = GasMask_GearGogglesVisual_Stage4
	ElseIf (auiMenuItemID == Stage5)
		MaskOverlay.VisualFX = GasMask_GearGogglesVisual_Stage5
	ElseIf (auiMenuItemID == Stage6)
		MaskOverlay.VisualFX = GasMask_GearGogglesVisual_Stage6
	ElseIf (auiMenuItemID == NoGlass)
		MaskOverlay.VisualFX = NoEffect
	EndIf
EndEvent


; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Context Property Context Auto Const Mandatory
	Gear:MaskOverlay Property MaskOverlay Auto Const Mandatory
EndGroup


Group Properties
	VisualEffect Property GasMask_GearGogglesVisual_Stage1 Auto Const Mandatory
	VisualEffect Property GasMask_GearGogglesVisual_Stage2 Auto Const Mandatory
	VisualEffect Property GasMask_GearGogglesVisual_Stage3 Auto Const Mandatory
	VisualEffect Property GasMask_GearGogglesVisual_Stage4 Auto Const Mandatory
	VisualEffect Property GasMask_GearGogglesVisual_Stage5 Auto Const Mandatory
	VisualEffect Property GasMask_GearGogglesVisual_Stage6 Auto Const Mandatory
	VisualEffect Property NoEffect Auto Const
EndGroup
