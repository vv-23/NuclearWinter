ScriptName NuclearWinter:HeatSourcePatches Extends Quest

Event OnInIt()
	If (Game.IsPluginInstalled("simplecamping2.esp"))
		If Winter_FireMedium.HasForm(Game.GetFormFromFile(0x00019D81, "simplecamping2.esp")) == false
			Form campfire = Game.GetFormFromFile(0x00019D81, "simplecamping2.esp")
			Winter_FireMedium.AddForm(campfire)
			Debug.Notification("Nuclear Winter: Simple Camping 2.0 Added")
		EndIf
	EndIf
	If (Game.IsPluginInstalled("BuildableBurningCampfires.esp"))
		If Winter_FireMedium.HasForm(Game.GetFormFromFile(0x00000800, "BuildableBurningCampfires.esp")) == false
			Form campfire = Game.GetFormFromFile(0x00000800, "BuildableBurningCampfires.esp")
			Winter_FireMedium.AddForm(campfire)
			campfire = Game.GetFormFromFile(0x00000801, "BuildableBurningCampfires.esp") 
			Winter_FireMedium.AddForm(campfire)
			campfire = Game.GetFormFromFile(0x00000802, "BuildableBurningCampfires.esp") 
			Winter_FireMedium.AddForm(campfire)
			campfire = Game.GetFormFromFile(0x0000080F, "BuildableBurningCampfires.esp") 
			Winter_FireMedium.AddForm(campfire)
			campfire = Game.GetFormFromFile(0x00000819, "BuildableBurningCampfires.esp") 
			Winter_FireMedium.AddForm(campfire)
			campfire = Game.GetFormFromFile(0x0000081E, "BuildableBurningCampfires.esp") 
			Winter_FireMedium.AddForm(campfire)
			campfire = Game.GetFormFromFile(0x00000826, "BuildableBurningCampfires.esp") 
			Winter_FireMedium.AddForm(campfire)
			campfire = Game.GetFormFromFile(0x0000082A, "BuildableBurningCampfires.esp") 
			Winter_FireMedium.AddForm(campfire)
			campfire = Game.GetFormFromFile(0x0000082B, "BuildableBurningCampfires.esp") 
			Winter_FireMedium.AddForm(campfire)
			campfire = Game.GetFormFromFile(0x00000FC9, "BuildableBurningCampfires.esp") 
			Winter_FireMedium.AddForm(campfire)
			campfire = Game.GetFormFromFile(0x00000FCA, "BuildableBurningCampfires.esp") 
			Winter_FireMedium.AddForm(campfire)
			campfire = Game.GetFormFromFile(0x00000FCB, "BuildableBurningCampfires.esp") 
			Winter_FireMedium.AddForm(campfire)
			Debug.Notification("Nuclear Winter: Buildable Fireplaces Added")
		EndIf
	EndIf
EndEvent

Formlist Property Winter_FireMedium Auto
