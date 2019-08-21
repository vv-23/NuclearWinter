Scriptname NuclearWinter:Player:SevereHypothermia extends ActiveMagicEffect 

import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log

int CryoDamageTimer = 0
Actor Player

Event OnInIt()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Freezing"
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Player = Game.GetPlayer()
	Winter_CryoFreeze.Cast(Player, Player)
	Winter_SevereHypothermiaIMOD.ApplyCrossFade(10.0)
	
	StartTimer(15, CryoDamageTimer)
	WriteLine(Log, "Applying Severe Hypothermia.")
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	CancelTimer(CryoDamageTimer)
	Winter_SevereHypothermiaIMOD.Remove()
	Player.DispelSpell(Winter_CryoFreeze)
	WriteLine(Log, "Removing Severe Hypothermia.")
EndEvent

Event OnTimer(int aiTimerID)
	If aiTimerID == CryoDamageTimer
		Winter_CryoFreeze.Cast(Player, Player)
		StartTimer(15, CryoDamageTimer)
		If Thermodynamics.CoreTemperature <= 60.0
			Player.Kill()
		EndIf
	EndIf
EndEvent

Spell Property Winter_CryoFreeze Auto
EffectShader Property Winter_SevereHypothermia_FXS Auto
ImageSpaceModifier Property Winter_SevereHypothermiaIMOD Auto

World:Thermodynamics Property Thermodynamics Auto Const
