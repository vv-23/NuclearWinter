Scriptname NuclearWinter:Player:Shivering extends ActiveMagicEffect 

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
	int instanceID = Winter_Shivering_SFX.Play(Game.GetPlayer())
	Sound.SetInstanceVolume(instanceID, 1.0)
EndEvent

Sound Property Winter_Shivering_SFX Auto 