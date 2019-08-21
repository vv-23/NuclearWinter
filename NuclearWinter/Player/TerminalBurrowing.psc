Scriptname NuclearWinter:Player:TerminalBurrowing extends ActiveMagicEffect 

import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log

Actor Player

Event OnInIt()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Freezing"
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Player = Game.GetPlayer()
	RegisterForPlayerSleep()
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UnRegisterForPlayerSleep()
EndEvent

Event OnPlayerSleepStart(float afSleepStartTime, float afDesiredSleepEndTime, ObjectReference akBed)
	If (Thermodynamics.IsInWarmLocation == false && HeatSource.IsInHeatSource == false)
		Winter_DiedInSleep.Show()
		Utility.Wait(4.0)
		Player.Kill()
	EndIf
EndEvent

World:Thermodynamics Property Thermodynamics Auto Const Mandatory
World:HeatSource Property HeatSource Auto Const Mandatory
Message Property Winter_DiedInSleep Auto 