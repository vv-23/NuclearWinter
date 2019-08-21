ScriptName NuclearWinter:Gear:Equipment extends NuclearWinter:Core:Required
{QUST:NuclearWinter_Gear}
import NuclearWinter
import NuclearWinter:Context
import Actor
import Shared:Log

UserLog Log

CustomEvent OnChanged

; List of Currently Equipped Armors
FormList CurrentlyEquippedArmor


; Events
;---------------------------------------------

Event OnInitialize()
	Log = GetLog(self)
	Log.FileName = "Gear"
EndEvent


Event OnEnable()
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForRemoteEvent(Player, "OnItemUnequipped")
EndEvent


Event OnDisable()
	UnregisterForRemoteEvent(Player, "OnItemEquipped")
	UnregisterForRemoteEvent(Player, "OnItemUnequipped")
EndEvent


; Methods
;---------------------------------------------

Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	Utility.wait(0.6)
	Armor equipment = akBaseObject as Armor
	If (Player.IsEquipped(equipment))
		UpdateExposure()
	Else
		WriteLine(Log, "The equipment is not actually equipped.")
	EndIf
EndEvent


Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	Utility.wait(0.6)
	Armor equipment = akBaseObject as Armor
	If (IsSupported(equipment))
		If (Player.IsEquipped(equipment) == false)
			UpdateExposure()
		Else
			WriteLine(Log, "The equipment is not actually unequipped.")
		EndIf
	EndIf	
EndEvent


; Functions
;---------------------------------------------

bool Function UpdateExposure()
	WornItem Item
	FormList EquippedArmor
	int i = 0
	While(i < 28)
		Item = Player.GetWornItem(i, false)
		If(EquippedArmor.HasForm(Item.item) == false)
			EquippedArmor.AddForm(Item.item)
		EndIf
	EndWhile
	If EquippedArmor == CurrentlyEquippedArmor
		WriteLine(Log, "There is no change to equipment exposure.")
		return false
	Else
		i = 0
		While(i < EquippedArmor.GetSize() - 1)
			If Database.Contains(EquippedArmor.GetAt(i) as Armor)
				Exposure = Exposure + Database.GetExposure(Item)
			EndIf
		EndWhile
		SendCustomEvent("OnChanged")
		return true
	EndIf
EndFunction


; Properties
;---------------------------------------------


Group Properties
	GlobalVariable Property Winter_Exposure Auto 
EndGroup


Group ReadOnly
	Int Property Exposure Hidden
		Int Function Get()
			return	Winter_Exposure.GetValueInt()
		EndFunction
		Function Set(Int value)
			Winter_Exposure.SetValueInt(value)
		EndFunction
	EndProperty
EndGroup

