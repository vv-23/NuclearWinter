Scriptname NuclearWinter:Player:Alcohol extends ActiveMagicEffect 

import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log

Event OnInIt()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Beverages"
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Equipment.UpdateExposure()
	Writeline(Log, "Alcohol has started heating")
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Equipment.UpdateExposure()
	Writeline(Log, "Alcohol has warn off")
EndEvent

Gear:Equipment Property Equipment Auto Const Mandatory