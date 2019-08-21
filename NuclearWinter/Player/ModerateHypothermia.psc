Scriptname NuclearWinter:Player:ModerateHypothermia extends ActiveMagicEffect 

import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log


Event OnInIt()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Freezing"
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Winter_ModerateHypothermiaIMOD.ApplyCrossFade(10.0)
	Winter_Freezing_ModerateHypothermia_Damage.Cast(Game.GetPlayer(),Game.GetPlayer())
	WriteLine(Log, "Applying Moderate Hypothermia.")
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Winter_ModerateHypothermiaIMOD.Remove()
	WriteLine(Log, "Removing Moderate Hypothermia.")
EndEvent

ImageSpaceModifier Property Winter_ModerateHypothermiaIMOD Auto Const
Spell Property Winter_Freezing_ModerateHypothermia_Damage Auto
