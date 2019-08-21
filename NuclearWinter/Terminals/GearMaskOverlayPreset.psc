ScriptName NuclearWinter:Terminals:GearMaskOverlayPreset extends Terminal
import NuclearWinter
import Shared:Log

UserLog Log

int ReturnID = 6 const
int OverlayID = 1 const
int LensID = 2 const
int BlurID = 3 const
int NoneID = 4 const
int DesaturateID = 5 const


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
	ElseIf (auiMenuItemID == LensID)
		MaskOverlay.ImageSpace = NuclearWinter_GearScreenFX_Heavy
	ElseIf (auiMenuItemID == BlurID)
		MaskOverlay.ImageSpace = NuclearWinter_GearScreenFX
	ElseIf (auiMenuItemID == NoneID)
		MaskOverlay.ImageSpace = NuclearWinter_GearNoFX
	ElseIf (auiMenuItemID == DesaturateID)
		MaskOverlay.ImageSpace = NuclearWinter_GearDesaturateFX
	EndIf
EndEvent


; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Context Property Context Auto Const Mandatory
	Gear:MaskOverlay Property MaskOverlay Auto Const Mandatory
EndGroup


Group Properties
	ImageSpaceModifier Property NuclearWinter_GearScreenFX Auto Const Mandatory
	ImageSpaceModifier Property NuclearWinter_GearScreenFX_Heavy Auto Const Mandatory
	ImageSpaceModifier Property NuclearWinter_GearNoFX Auto
	ImageSpaceModifier Property NuclearWinter_GearDesaturateFX Auto Const Mandatory
EndGroup
