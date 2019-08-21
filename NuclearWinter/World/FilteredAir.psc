Scriptname NuclearWinter:World:FilteredAir extends ActiveMagicEffect

import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Radiation.CheckRadiation()
EndEvent

Group Context
	World:Radiation Property Radiation Auto Const Mandatory
EndGroup

