Scriptname NuclearWinter:FrozenOnesLeveledActor extends Quest

Event OnInit()
	AddFrozenOnes()
EndEvent

Function AddFrozenOnes()
	LCharFeralGhoulGlowingOne.AddForm(Frozen_encFeralGhoulFrozen01, 1)
	LCharFeralGhoulGlowingOne.AddForm(Frozen_encFeralGhoulFrozen02, 40)
	LCharFeralGhoulGlowingOne.AddForm(Frozen_encFeralGhoulFrozen03, 58)
	LCharFeralGhoulGlowingOneAmbushLegendary.AddForm(encFeralGhoulFrozen01_Legendary, 1)
	LCharFeralGhoulGlowingOneAmbushLegendary.AddForm(encFeralGhoulFrozen02_Legendary, 40)
	LCharFeralGhoulGlowingOneAmbushLegendary.AddForm(encFeralGhoulFrozen03_Legendary, 58)
	LCharFeralGhoulGlowingOneLegendary.AddForm(encFeralGhoulFrozen01_Legendary, 1)
	LCharFeralGhoulGlowingOneLegendary.AddForm(encFeralGhoulFrozen02_Legendary, 40)
	LCharFeralGhoulGlowingOneLegendary.AddForm(encFeralGhoulFrozen03_Legendary, 58)
EndFunction

Group Actors
	Form Property encFeralGhoulFrozen01_Legendary Auto
	Form Property encFeralGhoulFrozen02_Legendary Auto
	Form Property encFeralGhoulFrozen03_Legendary Auto
	Form Property Frozen_encFeralGhoulFrozen01 Auto
	Form Property Frozen_encFeralGhoulFrozen02 Auto
	Form Property Frozen_encFeralGhoulFrozen03 Auto
	LeveledActor Property LCharFeralGhoulGlowingOne Auto
	LeveledActor Property LCharFeralGhoulGlowingOneAmbushLegendary Auto
	LeveledActor Property LCharFeralGhoulGlowingOneLegendary Auto
EndGroup

