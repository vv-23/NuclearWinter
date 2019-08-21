Scriptname NuclearWinter:Player:Frostnip extends ActiveMagicEffect 

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
	Winter_Cold_Frostnip_Damage.Cast(Game.GetPlayer(),Game.GetPlayer())
	WriteLine(Log, "Applying Frostnip.")
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	WriteLine(Log, "Removing Frostnip.")
EndEvent

Spell Property Winter_Cold_Frostnip_Damage Auto
