Scriptname NuclearWinter:Player:MinorHypothermia extends ActiveMagicEffect 

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
	;Winter_MinorHypothermia_FXS.Play(Game.GetPlayer())
	Winter_MinorHypothermiaIMOD.ApplyCrossFade(10.0)
	WriteLine(Log, "Applying Mild Hypothermia.")
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	;Winter_MinorHypothermia_FXS.Stop(Game.GetPlayer())
	Winter_MinorHypothermiaIMOD.Remove()
	WriteLine(Log, "Removing Mild Hypothermia.")
EndEvent

EffectShader Property Winter_MinorHypothermia_FXS Auto
ImageSpaceModifier Property Winter_MinorHypothermiaIMOD Auto
