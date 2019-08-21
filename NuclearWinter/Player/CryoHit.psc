Scriptname NuclearWinter:Player:CryoHit extends ActiveMagicEffect 

import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log

Event OnInIt()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Player"
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Thermodynamics.CoreTemperature = Thermodynamics.CoreTemperature - (CoreTemperatureDamage / ((Thermodynamics.Exposure + 1) * 0.1)) 
	Writeline(Log, "CryoHit, new Core Temp: " + Thermodynamics.CoreTemperature)
EndEvent

Group Properties
	World:Thermodynamics Property Thermodynamics Auto Const Mandatory
	float Property CoreTemperatureDamage Auto
	{Determines how much the player's Core Body Temperature will be damaged upon taking cryo damage}
EndGroup
