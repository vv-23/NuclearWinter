Scriptname NuclearWinter:Player:Confusion extends ActiveMagicEffect 

import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log

int ImageSpaceApplyTimer = 0
Actor Player

Event OnInIt()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Freezing"
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Player = Game.GetPlayer()
	Winter_Freezing_Confusion_Damage.Cast(Game.GetPlayer(),Game.GetPlayer())
	StartTimer(1, ImageSpaceApplyTimer)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	;Winter_Confused.Remove()
EndEvent

Event OnTimer(int aiTimerID)
	If (ImageSpaceApplyTimer == aiTimerID)
		Winter_Confused.Apply(1.0)
		StartTimer(30,ImageSpaceApplyTimer)
	EndIf
EndEvent

ImageSpaceModifier Property Winter_Confused Auto
Spell Property Winter_Freezing_Confusion_Damage Auto
