Scriptname NuclearWinter:Gear:FoodExpire extends ActiveMagicEffect 

import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log
Actor Player
int CurrentFood

Event OnInIt()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Food"
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Player = Game.GetPlayer()
	If FoodHandling.FoodToggle
		If FoodHandling.SpellsToIgnore[FoodHandling.Winter_WarmFoods.Find(Winter_Food)] < 1
			FoodHandling.UnRegisterForRemoved()
			Player.RemoveItem(Winter_Food, 1, true)
			FoodHandling.RegisterForRemoved()
			Player.AddItem(Winter_Cold_Food, 1, true)
			WriteLine(Log, "FoodExpire: OnEffectFinish- Added Cold Food")
		Else
			FoodHandling.SpellsToIgnore[FoodHandling.Winter_WarmFoods.Find(Winter_Food)] = FoodHandling.SpellsToIgnore[FoodHandling.Winter_WarmFoods.Find(Winter_Food)] - 1
			WriteLine(Log, "FoodExpire: OnEffectFinish- Did not add Cold Food")
		EndIf
	EndIf
	
EndEvent

Potion Property Winter_Food Auto 
Potion Property Winter_Cold_Food Auto
Gear:FoodHandling Property FoodHandling Auto Const 
