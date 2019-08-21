Scriptname NuclearWinter:Gear:MaskEquip extends NuclearWinter:Core:Required
{QUST:NuclearWinter_Gear}
import NuclearWinter
import NuclearWinter:Context
import NuclearWinter:Player:Animation
import Shared:Log

UserLog Log

int instanceID = 1
int recent

; Events
;---------------------------------------------

Event OnInitialize()
	Log = GetLog(self)
	Log.FileName = "Gear"
EndEvent


Event OnEnable()
	RegisterForCustomEvent(Mask, "OnChanged")
EndEvent


Event OnDisable()
	UnregisterForCustomEvent(Mask, "OnChanged")
EndEvent


Event NuclearWinter:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
	If (Mask.IsGasMask && Player.WornHasKeyword(ArmorTypePower) == false)
	
		;Draw
		
		If(Mask.FormID == 0x001184C1) ; GasMaskwithGoggles
			If(IsFirstPerson)
				IdlePlay(Player, GasMaskwithGoggles_1stPUseGasMaskOnSelf, Log)
				GMWG_Draw_Fade.Apply()
			Else
				IdlePlay(Player, GasMaskwithGoggles_3rdPUseGasMaskOnSelf, Log)
			EndIf
		ElseIf(Mask.FormID == 0x000787D8) ; SingleVisor
			If(IsFirstPerson)
				IdlePlay(Player, SingleVisor_1stPUseGasMaskOnSelf, Log)
				GMWG_Draw_Fade.Apply()
			Else
				IdlePlay(Player, SingleVisor_3rdPUseGasMaskOnSelf, Log)
			EndIf
		ElseIf(Mask.FormID == 0x00007A77) ; M1A211
			If(IsFirstPerson)
				IdlePlay(Player, M1A211_1stPUseGasMaskOnSelf, Log)
				GMWG_Draw_Fade.Apply()
			Else
				IdlePlay(Player, M1A211_3rdPUseGasMaskOnSelf, Log)
			EndIf
		EndIf
		recent = Mask.FormID
		instanceID = GasMask_GearEquipDrawSFX.Play(Player)
		WriteLine(Log, "MaskEquip: draw recent = " + Mask.FormID)
		
		If(IsFirstPerson == false)
			;Equip InvisibleHelm
			Mask.AnimationEquip = 1
			Player.Unequipitem(Mask.Equipped, true, true)
			Utility.Wait(1.05)
			Player.EquipItem(Mask.Equipped, False, True)
			WriteLine(Log, "AnimationEquip = " + Mask.AnimationEquip)
			Mask.AnimationEquip = 0
		EndIf
		
	ElseIf Player.WornHasKeyword(ArmorTypePower) == false
		; Withdraw 
		
		If(recent == 0x001184C1)
			If(IsFirstPerson)
				IdlePlay(Player, GasMaskwithGoggles_1stPUseRemoveGasMaskOnSelf, Log)
				GMWG_WithDraw_Fade.Apply()
			Else
				IdlePlay(Player, GasMaskwithGoggles_3rdPUseRemoveGasMaskOnSelf, Log)
			EndIf
		ElseIf(recent == 0x000787D8)
			If(IsFirstPerson)
				IdlePlay(Player, SingleVisor_1stPUseRemoveGasMaskOnSelf, Log)
				GMWG_WithDraw_Fade.Apply()
			Else
				IdlePlay(Player, SingleVisor_3rdPUseRemoveGasMaskOnSelf, Log)
			EndIf
		ElseIf(recent == 0x00007A77)
			If(IsFirstPerson)
				IdlePlay(Player, M1A211_1stPUseRemoveGasMaskOnSelf, Log)
				GMWG_WithDraw_Fade.Apply()
			Else
				IdlePlay(Player, M1A211_3rdPUseRemoveGasMaskOnSelf, Log)
			EndIf
		EndIf
		WriteLine(Log, "MaskEquip: withdraw recent = " + recent)
		instanceID = GasMask_GearEquipWithdrawSFX.Play(Player)	
		
	EndIf
	
EndEvent


; Properties
;---------------------------------------------

Group Context
	Gear:Mask Property Mask Auto Const Mandatory
EndGroup

Group Properties
	ImageSpaceModifier Property GMWG_Draw_Fade Auto Const Mandatory
	ImageSpaceModifier Property GMWG_WithDraw_Fade Auto Const Mandatory
	Sound Property GasMask_GearEquipDrawSFX Auto Const Mandatory
	Sound Property GasMask_GearEquipWithdrawSFX Auto Const Mandatory
	;1stP Draw
	Idle property GasMaskwithGoggles_1stPUseGasMaskOnSelf Auto Const Mandatory
	Idle property SingleVisor_1stPUseGasMaskOnSelf Auto Const Mandatory
	Idle property M1A211_1stPUseGasMaskOnSelf Auto Const Mandatory
	{IDLE: "1stPUseGasMaskOnSelf"}
	;3rdP Draw
	Idle property GasMaskwithGoggles_3rdPUseGasMaskOnSelf Auto Const Mandatory
	Idle property SingleVisor_3rdPUseGasMaskOnSelf Auto Const Mandatory
	Idle property M1A211_3rdPUseGasMaskOnSelf Auto Const Mandatory
	{IDLE: "3rdPUseGasMaskOnSelf"}
	;1stP Withdraw
	Idle property GasMaskwithGoggles_1stPUseRemoveGasMaskOnSelf Auto Const Mandatory
	Idle property SingleVisor_1stPUseRemoveGasMaskOnSelf Auto Const Mandatory
	Idle property M1A211_1stPUseRemoveGasMaskOnSelf Auto Const Mandatory
	{IDLE: "1stPUseRemoveGasMaskOnSelf"}
	;3rdP Withdraw
	Idle property GasMaskwithGoggles_3rdPUseRemoveGasMaskOnSelf Auto Const Mandatory
	Idle property SingleVisor_3rdPUseRemoveGasMaskOnSelf Auto Const Mandatory
	Idle property M1A211_3rdPUseRemoveGasMaskOnSelf Auto Const Mandatory
	{IDLE: "3rdPUseRemoveGasMaskOnSelf"}
	Keyword Property ArmorTypePower Auto Const Mandatory
EndGroup

Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Player.GetAnimationVariableBool("IsFirstPerson")
		EndFunction
	EndProperty
EndGroup
