ScriptName NuclearWinter:Gear:ExposureValues extends NuclearWinter:Core:Required
{QUST:Winter_ChangeArmor}
import NuclearWinter
import NuclearWinter:Context
import Actor
import Form
import Shared:Log

UserLog Log

Message Property Winter_NoArmorChanged Auto
Message Property Winter_ArmorChanged Auto
Armor[] Property CurrentlyEquippedArmor Auto
int[] Property CurrentlyEquippedValues Auto
Gear:Database Property Database Auto

;CHANGE TO GLOBALS FOR THE JSON
int Property BipedToAdd Auto
int Property ValueToAdd Auto

Event OnInitialize()
	Log = GetLog(self)
	Log.FileName = "Winter ExposureValues"
	WriteLine(Log, "Equipment: OnInitialize()")
EndEvent

Event OnEnable()
	CurrentlyEquippedArmor = new Armor[30]
	CurrentlyEquippedValues = new int [30]
	WriteLine(Log, "ExposureValues: OnEnable()")
	Initialize()
EndEvent


Event OnDisable()
	WriteLine(Log, "ExposureValues: OnDisable()")
EndEvent

Function ChangeArmor()
	Utility.Wait(2.0)
	If CurrentlyEquippedArmor[BipedToAdd] != None
		Database.ChangeArmor(CurrentlyEquippedArmor[BipedToAdd], ValueToAdd)
		Winter_ArmorChanged.Show(BipedToAdd, ValueToAdd)
		WriteLine(Log, "ExposureValues: BipedToAdd: " + BipedToAdd + " | ValueToAdd: " + ValueToAdd)
	Else
		Winter_NoArmorChanged.Show(BipedToAdd)
		;Post some kind of message that it is invalid
	EndIf
	Print()
EndFunction

Function ChangeAllArmor()
	Utility.Wait(2.0)
	int i = 0
	While i < 30
		If CurrentlyEquippedArmor[i] != None
			Database.ChangeArmor(CurrentlyEquippedArmor[i], ValueToAdd)
			Winter_ArmorChanged.Show(i, ValueToAdd)
			WriteLine(Log, "ExposureValues: BipedToAdd: " + i + " | ValueToAdd: " + ValueToAdd)
		EndIf
		i += 1
	EndWhile
	Print()
EndFunction

Function Print()
	int i = 0
	While i < 30
		If CurrentlyEquippedArmor[i] != None
			WriteLine(Log, "WornItem: " + CurrentlyEquippedArmor[i].GetName() + " | Biped Slot Index: " + i + " | Exposure: " + CurrentlyEquippedValues[i])
		Else
			WriteLine(Log, "WornItem: None | Biped Slot Index: " + i + " | Exposure: " + CurrentlyEquippedValues[i])
		EndIf
		i += 1
	EndWhile
	WriteLine(Log, "==============================================================================")
Endfunction

Function Initialize()
	int i = 0
	While i < 30
		CurrentlyEquippedValues[i] = 0
		i += 1
	EndWhile
Endfunction



