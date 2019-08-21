Scriptname NuclearWinter:Gear:BeverageExpire extends ActiveMagicEffect 

import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log
Actor Player

Event OnInIt()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Beverage"
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Player = Game.GetPlayer()
	If BeverageHandling.FoodToggle
		If BeverageHandling.SpellsToIgnore[BeverageHandling.Winter_Beverages.Find(Winter_Beverage)] < 1
			BeverageHandling.UnRegisterForRemoved()
			Player.RemoveItem(Winter_Beverage, 1, true)
			BeverageHandling.RegisterForRemoved()
			Player.AddItem(Winter_Frozen_Beverage, 1, true)
			WriteLine(Log, "FoodExpire: OnEffectFinish- Added Cold Food")
		Else
			BeverageHandling.SpellsToIgnore[BeverageHandling.Winter_Beverages.Find(Winter_Beverage)] = BeverageHandling.SpellsToIgnore[BeverageHandling.Winter_Beverages.Find(Winter_Beverage)] - 1
			WriteLine(Log, "FoodExpire: OnEffectFinish- Did not add Cold Food")
		EndIf
	EndIf
	
EndEvent

Potion Property Winter_Beverage Auto 
Potion Property Winter_Frozen_Beverage Auto
Gear:BeverageHandling Property BeverageHandling Auto Const 
