Scriptname NuclearWinter:Player:Pneumonia extends ActiveMagicEffect 

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
	Winter_Freezing_Pneumonia_Damage.Cast(Game.GetPlayer(),Game.GetPlayer())
	WriteLine(Log, "Applying Pneumonia.")
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	WriteLine(Log, "Removing Pneumonia.")
EndEvent

Spell Property Winter_Freezing_Pneumonia_Damage Auto
