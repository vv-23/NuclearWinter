Scriptname NuclearWinter:NPC:CloakApply extends ActiveMagicEffect
{MGEF:NuclearWinter_CloakApplyingEffect}
import Shared:Log

UserLog Log


; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_NPC"
EndEvent


Event OnEffectStart(Actor akTarget, Actor akCaster)
	akTarget.AddSpell(Winter_NPC_CloakEquip, false)
	WriteLine(Log, "Added the spell '"+Winter_NPC_CloakEquip+"' to '"+akTarget+"'.")
EndEvent


; Properties
;---------------------------------------------

Group Properties
	Spell Property Winter_NPC_CloakEquip Auto Const Mandatory
EndGroup
