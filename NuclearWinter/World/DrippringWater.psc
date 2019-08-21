Scriptname NuclearWinter:World:DrippringWater extends ActiveMagicEffect 

import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log

Spell Property Winter_DrippingWater Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	akTarget.DispelSpell(Winter_DrippingWater)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Winter_DrippingWater.Cast(akTarget,akTarget)
EndEvent 