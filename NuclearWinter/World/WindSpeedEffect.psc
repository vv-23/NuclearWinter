Scriptname NuclearWinter:World:WindSpeedEffect extends ActiveMagicEffect 

import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log

Event OnInIt()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Climate"
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Winter_CurrentWindSpeed.SetValue(WindSpeedSetting)
	Writeline(Log, "Winter_CurrentWindSpeed Set to " + WindSpeedSetting)
EndEvent

GlobalVariable Property Winter_CurrentWindSpeed Auto 
Float Property WindSpeedSetting Auto
