ScriptName NuclearWinter:Player:Conditions:IsPlayerInConversation extends ActiveMagicEffect
import NuclearWinter
import Shared:Log

UserLog Log


; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Player"
EndEvent


Event OnEffectStart(Actor akTarget, Actor akCaster)
	WriteLine(Log, "OnEffectStart")
	Speech.InvokeChanged(true)
EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)
	WriteLine(Log, "OnEffectFinish")
    Speech.InvokeChanged(false)
EndEvent


; Properties
;---------------------------------------------

Group Context
	Player:Speech Property Speech Auto Const Mandatory
EndGroup
