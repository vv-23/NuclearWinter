Scriptname NuclearWinter:World:CampingsiteCompatability extends NuclearWinter:Core:Optional

import NuclearWinter
import NuclearWinter:Context
import Shared:Log

FormList Property Winter_FireMedium Auto Const
Activator Campfire

Event OnEnable()
	RegisterForRemoteEvent(Player, "OnPlayerLoadGame")
	If (Game.IsPluginInstalled("Campsite.esp"))
		Campfire = Game.GetFormFromFile(0x000027B5, "Campsite.esp") as Activator
		int index = Winter_FireMedium.Find(Campfire)
		If index < 0
			Winter_FireMedium.AddForm(Campfire)
			Debug.Notification("Campsite Compatability Added")
		EndIf
		;Debug.Notification("Campsite Compatability Ignored")
	Else
		;Debug.Notification("Campsite Not Installed")
	EndIf
	If (Game.IsPluginInstalled("Campsite - Nuclear Winter.esp"))
		Campfire = Game.GetFormFromFile(0x000027B5, "Campsite - Nuclear Winter.esp") as Activator
		int index = Winter_FireMedium.Find(Campfire)
		If index < 0
			Winter_FireMedium.AddForm(Campfire)
			Debug.Notification("Campsite - Nuclear Winter Compatability Added")
		EndIf
		;Debug.Notification("Campsite Compatability Ignored")
	Else
		;Debug.Notification("Campsite - Nuclear Winter Not Installed")
	EndIf
EndEvent

Event OnDisable()
	UnregisterForRemoteEvent(Player, "OnPlayerLoadGame")
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
	If (Game.IsPluginInstalled("Campsite.esp"))
		Campfire = Game.GetFormFromFile(0x000027B5, "Campsite.esp") as Activator
		int index = Winter_FireMedium.Find(Campfire)
		If index < 0
			Winter_FireMedium.AddForm(Campfire)
			Debug.Notification("Campsite Compatability Added")
		EndIf
		;Debug.Notification("Campsite Compatability Ignored")
	Else
		;Debug.Notification("Campsite Not Installed")
	EndIf
	If (Game.IsPluginInstalled("Campsite - Nuclear Winter.esp"))
		Campfire = Game.GetFormFromFile(0x000027B5, "Campsite - Nuclear Winter.esp") as Activator
		int index = Winter_FireMedium.Find(Campfire)
		If index < 0
			Winter_FireMedium.AddForm(Campfire)
			Debug.Notification("Campsite - Nuclear Winter Compatability Added")
		EndIf
		;Debug.Notification("Campsite Compatability Ignored")
	Else
		;Debug.Notification("Campsite - Nuclear Winter Not Installed")
	EndIf
EndEvent
