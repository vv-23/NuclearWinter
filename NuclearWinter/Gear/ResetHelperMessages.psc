ScriptName NuclearWinter:Gear:ResetHelperMessages extends NuclearWinter:Core:Required

import NuclearWinter
import NuclearWinter:Context
import Shared:Log

Function Reset()
	BeverageHandling.ResetHelpers()
	FoodHandling.ResetHelpers()
	Freezing.ResetHelpers()
EndFunction

Gear:BeverageHandling Property BeverageHandling Auto Const 
Gear:FoodHandling Property FoodHandling Auto Const 
Player:Freezing Property Freezing Auto Const
