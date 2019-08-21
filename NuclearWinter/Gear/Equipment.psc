ScriptName NuclearWinter:Gear:Equipment extends NuclearWinter:Core:Required
{QUST:Winter_Gear}
import NuclearWinter
import NuclearWinter:Context
import Actor
import Form
import Shared:Log

UserLog Log

CustomEvent OnChanged

; List of Currently Equipped Armors
Armor[] CurrentlyEquippedArmor
int ExposureTimer = 1

; Events
;---------------------------------------------

Event OnInitialize()
	Log = GetLog(self)
	Log.FileName = "Winter Gear"
	WriteLine(Log, "Equipment: OnInitialize()")
EndEvent


Event OnEnable()
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForRemoteEvent(Player, "OnItemUnequipped")
	Winter_GameplayToggle.SetValue(1.0)
	;UpdateExposure()
	WriteLine(Log, "Equipment: OnEnable()")
EndEvent


Event OnDisable()
	UnregisterForRemoteEvent(Player, "OnItemEquipped")
	UnregisterForRemoteEvent(Player, "OnItemUnequipped")
	WriteLine(Log, "Equipment: OnDisable()")
EndEvent


Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	Utility.wait(0.6)
	Armor equipment = akBaseObject as Armor
	If (akBaseObject as Armor)
		If (Player.IsEquipped(equipment))
			StartTimer(2.5, ExposureTimer)
			;UpdateExposure()
		Else
			WriteLine(Log, "The equipment is not actually equipped.")
		EndIf
	Else
		WriteLine(Log, "The equipment is not Armor.")
	EndIf
EndEvent


Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	Utility.wait(0.6)
	Armor equipment = akBaseObject as Armor
	If (akBaseObject as Armor)
		If (Player.IsEquipped(equipment) == false)
			StartTimer(2.5, ExposureTimer)
			;UpdateExposure()
		Else
			WriteLine(Log, "The equipment is not actually unequipped.")
		EndIf
	Else
		WriteLine(Log, "The equipment is not Armor.")
	EndIf
EndEvent

Event OnTimer(int aiTimerID)
	If aiTimerID == ExposureTimer
		UpdateExposure()
		InsulationWidget.UpdateInsulation()
		;TEMP Debug
		;ExposureValues.Print()
		;Winter_CurrentExposure.Show(Exposure)
	EndIf
EndEvent


; Functions
;---------------------------------------------

Function UpdateExposure()
	WornItem Item
	int i = 0
	Exposure = 0
	int value = 0
	WriteLine(Log, "==========================StartUpdateExposure()==========================")
	If UniversalExposure == false
		While(i <= 29)
			Item = Player.GetWornItem(i)
			If (Item.item as Armor != None)
				If ExposureValues.CurrentlyEquippedArmor[i] != Item.item
					ExposureValues.CurrentlyEquippedArmor[i] = Item.item as Armor
				EndIf
				WriteLine(Log, "WornItem: " + Item.item.GetName() + " | Biped Slot Index: " + i)
				value = Database.GetExposure(Item.item as Armor)
				ExposureValues.CurrentlyEquippedValues[i] = value
				Exposure = Exposure + value
			Else
				ExposureValues.CurrentlyEquippedArmor[i] = None
				ExposureValues.CurrentlyEquippedValues[i] = 0				
				WriteLine(Log, "WornItem: None")
			EndIf
			i = i + 1
		EndWhile
		Exposure = Exposure + Math.Ceiling(Player.GetValue(FrostResist))
		If Exposure > MaxInsulation
			Exposure = MaxInsulation
		EndIf
	Else
		Exposure = Math.Ceiling((Player.GetValue(RadResistExposure) * 0.25) + ((Player.GetValue(DamageResist) + Player.GetValue(EnergyResist)) * 0.666))
		If Exposure > MaxInsulation 
			Exposure = MaxInsulation
		EndIf
		Exposure = Exposure + Math.Ceiling(Player.GetValue(FrostResist))
	EndIf
	
	If Player.HasMagicEffect(Winter_AlcoholDebuffEffect)
		Exposure = Exposure - 30
		WriteLine(Log, "Alcohol: -30 Exposure")
	EndIf
	WriteLine(Log, "==========================EndUpdateExposure()==========================")
	If Exposure < 0
		Exposure = 0
	EndIf
	SendCustomEvent("OnChanged")
	WriteLine(Log, "Equipment: New Exposure = " + Exposure)
	WriteLine(Log, " ")
	Winter_CurrentExposure.Show(Exposure)
EndFunction

bool Function IsSupported(Armor akEquipment)
	If (akEquipment)
		return Database.Contains(akEquipment)
	Else
		return false
	EndIf
EndFunction

Function SetEquipment(bool value)
	If value
		RegisterForRemoteEvent(Player, "OnItemEquipped")
		RegisterForRemoteEvent(Player, "OnItemUnequipped")
		StartTimer(2.5, ExposureTimer)
		WriteLine(Log, "Equipment: OnEnable()")
	Else
		UnregisterForRemoteEvent(Player, "OnItemEquipped")
		UnregisterForRemoteEvent(Player, "OnItemUnequipped")
		WriteLine(Log, "Equipment: OnEnable()")
	EndIf
EndFunction

Function SetInsulation()
	int button = Winter_InsulationSelection.Show()
	If button == 0
		MaxInsulation = 40
		ToggleGameplaySystem.MaxInsulation = 40
		ToggleGameplaySystem.InsulationSetting = 1
		UniversalExposure = true
	ElseIf button == 1
		MaxInsulation = 100
		ToggleGameplaySystem.MaxInsulation = 100
		ToggleGameplaySystem.InsulationSetting = 0
		UniversalExposure = false
	Endif
	StartTimer(2.5, ExposureTimer)
EndFunction


; Properties
;---------------------------------------------

Group Context
	Terminals:ToggleGameplaySystem Property ToggleGameplaySystem Auto Const Mandatory
	Gear:Database Property Database Auto Const Mandatory
	Gear:ExposureValues Property ExposureValues Auto Const Mandatory
	GUI:InsulationWidget Property InsulationWidget Auto Const Mandatory
EndGroup

Group Properties
	Int Property MaxInsulation = 100 Auto
	Bool Property UniversalExposure = true Auto
	GlobalVariable Property Winter_Exposure Auto 
	GlobalVariable Property Winter_GameplayToggle Auto
	Message Property Winter_CurrentExposure Auto
	MagicEffect Property Winter_AlcoholDebuffEffect Auto
	ActorValue Property DamageResist Auto
	ActorValue Property EnergyResist Auto
	ActorValue Property FrostResist Auto
	ActorValue Property RadResistExposure Auto
	Message Property Winter_InsulationSelection Auto
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

