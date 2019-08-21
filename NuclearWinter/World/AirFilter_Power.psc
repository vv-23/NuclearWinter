Scriptname NuclearWinter:World:AirFilter_Power extends ObjectReference

import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log
ObjectReference AirFilter
String MessageText
Actor Player
int UpdateTimer = 0
int UpdateTimerOne = 1
int UpgradeLevel = 0
; Events
;---------------------------------------------

Event OnLoad()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Air Filter"
	Player = Game.GetPlayer()
	Player.AddSpell(GasMask_AirFilter_Spell)
	WriteLine(Log, "Air Filter Spell Added")
	GoToState("SpellOff")
EndEvent

State SpellOff

	Event OnBeginState(string oldState)
		RegisterForDistanceLessThanEvent(Player, AirFilter, Distance)
	EndEvent

	Event OnPowerOn(ObjectReference akPowerGenerator)
		AirFilter = self
		WriteLine(Log, "Air Filter System Powered")
		RegisterForDistanceLessThanEvent(Player, AirFilter, Distance)
		WriteLine(Log, AirFilter + " Powered On")
		
		If (Player.GetDistance(AirFilter) <= Distance)
			WriteLine(Log, "Air Filteration System distance less than: " + Distance)
			GoToState("SpellOn")
		EndIf
	EndEvent

	Event OnDistanceLessThan(ObjectReference akObj1, ObjectReference akObj2, float afDistance)
		 If (Player.GetDistance(AirFilter) <= Distance && AirFilter.IsPowered() == true)
			WriteLine(Log, "Event:Air Filteration System distance less than: " + Distance)
			GasMask_Message_AirFiltered.Show()
			GoToState("SpellOn")
		EndIf
	EndEvent

EndState

State SpellOn

	Event OnBeginState(string oldState)
		GasMask_AirFilter_Spell.Cast(Player, Player)
		WriteLine(Log, "Air Filter Spell Cast")
		StartTimer(5.2, UpdateTimer)
		If(Player.HasMagicEffect(GasMask_RadiationEffect) == true)
			Radiation.Dispel_Rad()
		EndIf
	EndEvent

	
EndState

Event OnActivate(ObjectReference akActionRef)
	int message_num
	if akActionRef == Game.GetPlayer()
	
		If UpgradeLevel == 0
			message_num = UpgradeMessage_Level1.show()
			if message_num == 0 && Player.GetItemCount(GasMask_GearFilter) >= 5 && Player.GetItemCount(c_Aluminum_scrap) >= 10 && Player.GetItemCount(c_Screws_scrap) >= 5
				;show the message that tells the player they have upgraded
				Player.RemoveItem(GasMask_GearFilter, 5)
				Player.RemoveItem(c_Aluminum_scrap, 10)
				Player.RemoveItem(c_Screws_scrap, 5)
				UpgradeLevel = 1
				UpgradeSuccessful_Level1.show()
				AirFilter.ModValue(GasMask_AirFilter_Distance, 1500.0)
				Distance = 1500.0
			elseif Player.GetItemCount(GasMask_GearFilter) < 5 || Player.GetItemCount(c_Aluminum_scrap) < 10 || Player.GetItemCount(c_Screws_scrap) < 5
				;show the message that tells the player they don't have the proper components
				NoUpgradeMessage.show()
			endif
		EndIf
		
		If UpgradeLevel == 1
			message_num = UpgradeMessage_Level2.show()
			if message_num == 0 && Player.GetItemCount(GasMask_GearFilter) >= 10 && Player.GetItemCount(c_Aluminum_scrap) >= 20 && Player.GetItemCount(c_Circuitry_scrap) >= 10 && Player.GetItemCount(c_Screws_scrap) >= 5
				;show the message that tells the player they have upgraded
				Player.RemoveItem(GasMask_GearFilter, 10)
				Player.RemoveItem(c_Aluminum_scrap, 20)
				Player.RemoveItem(c_Screws_scrap, 5)
				Player.RemoveItem(c_Circuitry_scrap, 10)
				UpgradeLevel = 2
				UpgradeSuccessful_Level2.show()
				AirFilter.ModValue(GasMask_AirFilter_Distance, 1900.0)
				Distance = 1900.0
			elseif Player.GetItemCount(GasMask_GearFilter) < 10 || Player.GetItemCount(c_Aluminum_scrap) < 20 || Player.GetItemCount(c_Screws_scrap) < 5 || Player.GetItemCount(c_Circuitry_scrap) < 10
				;show the message that tells the player they don't have the proper components
				NoUpgradeMessage.show()
			endif
		EndIf
		
		If UpgradeLevel == 2
			message_num = UpgradeMessage_Level3.show()
			if message_num == 0 && Player.GetItemCount(GasMask_GearFilter) >= 10 && Player.GetItemCount(c_Aluminum_scrap) >= 20 && Player.GetItemCount(c_Circuitry_scrap) >= 10 && Player.GetItemCount(c_Copper_scrap) >= 10 && Player.GetItemCount(c_Screws_scrap) >= 5
				;show the message that tells the player they have upgraded
				Player.RemoveItem(GasMask_GearFilter, 10)
				Player.RemoveItem(c_Aluminum_scrap, 20)
				Player.RemoveItem(c_Circuitry_scrap, 10)
				Player.RemoveItem(c_Copper_scrap, 10)
				Player.RemoveItem(c_Screws_scrap, 5)
				UpgradeLevel = 3
				UpgradeSuccessful_Level3.show()
				AirFilter.ModValue(GasMask_AirFilter_Distance, 2500.0)
				Distance = 2500.0
			elseif Player.GetItemCount(GasMask_GearFilter) < 10 || Player.GetItemCount(c_Aluminum_scrap) < 20 || Player.GetItemCount(c_Screws_scrap) < 5 || Player.GetItemCount(c_Circuitry_scrap) < 10 || Player.GetItemCount(c_Copper_scrap) < 10
				;show the message that tells the player they don't have the proper components
				NoUpgradeMessage.show()
			endif
		EndIf
		
		If UpgradeLevel == 3
			message_num = UpgradeMessage_Level4.show()
			if message_num == 0 && Player.GetItemCount(GasMask_GearFilter) >= 15 && Player.GetItemCount(c_Aluminum_scrap) >= 30 && Player.GetItemCount(c_Circuitry_scrap) >= 10 && Player.GetItemCount(c_Copper_scrap) >= 10 && Player.GetItemCount(c_Screws_scrap) >= 5
				;show the message that tells the player they have upgraded
				Player.RemoveItem(GasMask_GearFilter, 15)
				Player.RemoveItem(c_Aluminum_scrap, 30)
				Player.RemoveItem(c_Circuitry_scrap, 10)
				Player.RemoveItem(c_Copper_scrap, 10)
				Player.RemoveItem(c_Screws_scrap, 5)
				UpgradeLevel = 4
				UpgradeSuccessful_Level4.show()
				AirFilter.ModValue(GasMask_AirFilter_Distance, 3300.0)
				Distance = 3300.0
			elseif Player.GetItemCount(GasMask_GearFilter) < 15 || Player.GetItemCount(c_Aluminum_scrap) < 30 || Player.GetItemCount(c_Screws_scrap) < 5 || Player.GetItemCount(c_Circuitry_scrap) < 10 || Player.GetItemCount(c_Copper_scrap) < 10
				;show the message that tells the player they don't have the proper components
				NoUpgradeMessage.show()
			endif
		EndIf
		
	endif
EndEvent

Event OnTimer(int aiTimerID)
	
	If(aiTimerID == UpdateTimer)
	
		;Player -------------------------------------
			If(Player.GetDistance(AirFilter) < Distance)
				WriteLine(Log, "Air Filteration System distance less than: " + Distance)
				GasMask_AirFilter_Spell.Cast(Player, Player)
				WriteLine(Log, "Air Filter Spell Cast")
				StartTimer(5.0, UpdateTimer)
				If(Player.HasMagicEffect(GasMask_RadiationEffect) == true)
					Radiation.Dispel_Rad()
				EndIf
			Else
				WriteLine(Log, "Air Filteration System outside Distance going to state SpellOff")
				Radiation.CheckRadiation()
				GoToState("SpellOff")
			EndIf
			
	EndIf
EndEvent

Event OnPowerOff()
	WriteLine(Log, AirFilter + " Powered Off")
	UnregisterForDistanceEvents(Player, AirFilter)
	CancelTimer(UpdateTimer)
	CancelTimer(UpdateTimerOne)
	Radiation.CheckRadiation()
	GoToState("SpellOff")
EndEvent

Event OnDistanceLessThan(ObjectReference akObj1, ObjectReference akObj2, float afDistance)
	{EMPTY}
EndEvent

; Properties
;---------------------------------------------

Group Context
	World:Radiation Property Radiation Auto Const Mandatory
EndGroup

Group Properties
	ActorValue Property GasMask_AirFilter_Distance Auto
	Form Property c_Aluminum_scrap Auto Const Mandatory
	Form Property c_Circuitry_scrap Auto Const Mandatory
	Form Property c_Copper_scrap Auto Const Mandatory
	Form Property c_Screws_scrap Auto Const Mandatory
	Potion Property GasMask_GearFilter Auto Const Mandatory
	Spell Property GasMask_AirFilter_Spell Auto Const Mandatory
	MagicEffect Property GasMask_RadiationEffect Auto Const Mandatory
	Message Property GasMask_Message_AirFiltered Auto
	Message Property UpgradeMessage Auto
	Message Property UpgradeMessage_Level1 Auto
	Message Property UpgradeSuccessful_Level1 Auto
	Message Property UpgradeMessage_Level2 Auto
	Message Property UpgradeSuccessful_Level2 Auto
	Message Property UpgradeMessage_Level3 Auto
	Message Property UpgradeSuccessful_Level3 Auto
	Message Property UpgradeMessage_Level4 Auto
	Message Property UpgradeSuccessful_Level4 Auto
	Message Property NoUpgradeMessage Auto
	float Property Distance Auto Mandatory
	{The distance from the player at which the spell can be cast}
EndGroup

