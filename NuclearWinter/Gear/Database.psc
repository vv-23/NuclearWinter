ScriptName NuclearWinter:Gear:Database extends NuclearWinter:Core:Required
{QUST:Winter_Gear}
import NuclearWinter
import NuclearWinter:Context
import Shared:Log
import Shared:Papyrus
import Form

UserLog Log
CustomEvent OnRefreshed

string UpdateState = "UpdateState" const

; Properties
;---------------------------------------------
Group Context
	Gear:Equipment Property Equipment Auto Const Mandatory
EndGroup

Group Database
	int Property Invalid = -1 AutoReadOnly
	FormList Property Winter_ExposureArmorLists Auto
	FormList Property Winter_ExposureArmorLists_dyn Auto
	FormList Property Winter_ExposureKeywordList Auto
EndGroup


; Events
;---------------------------------------------

Event OnInitialize()
	Log = GetLog(self)
	Log.FileName = "Winter Gear"
EndEvent


Event OnEnable()
	ChangeState(self, UpdateState)
	;RegisterForRemoteEvent(Player, "OnPlayerLoadGame")
EndEvent


Event OnDisable()
	;UnregisterForRemoteEvent(Player, "OnPlayerLoadGame")
EndEvent


Event Actor.OnPlayerLoadGame(Actor akSender)
	ChangeState(self, UpdateState)
EndEvent


; Functions
;---------------------------------------------

; Checks an armor for any cooresponding Exposure keywords and adds that exposure if it exists
int Function CheckExposureKeywords(Armor akArmor)
	int i = 0
	While (i < Winter_ExposureKeywordList.GetSize())
		If akArmor.HasKeyword(Winter_ExposureKeywordList.GetAt(i) as Keyword)
			return (i * 5)
		Else
			i += 1
		EndIf
	EndWhile
	return 0
EndFunction

int Function GetExposure(Armor akArmor)
	If akArmor != None
		WriteLine(Log, "		==================GetExposure==================")
		int value = CheckExposureKeywords(akArmor)
		If value > 0
			WriteLine(Log,"			" + akArmor.GetName() + ": " + value)
			WriteLine(Log, "		===============================================")
			return value
		EndIf
		int i = 0
		While (i < Winter_ExposureArmorLists_dyn.GetSize())
			If (Winter_ExposureArmorLists_dyn.GetAt(i) as FormList).HasForm(akArmor)
				WriteLine(Log,"			" + akArmor.GetName() + ": " + (i * 5))
				WriteLine(Log, "		===============================================")
				return i * 5
			EndIf
			i += 1
		EndWhile
		WriteLine(Log, "			" +akArmor.GetName() + ": 0 | Armor not in Collection.")
		WriteLine(Log, "		===============================================")
		return 0
	Else
		WriteLine(Log,"			" + akArmor.GetName() + ": 0 | Armor is None.")
		WriteLine(Log, "		===============================================")
		return 0
	EndIf
EndFunction


bool Function Contains(Armor akArmor)
	If (akArmor != None)
		int i = 0
		While (i < Winter_ExposureArmorLists_dyn.GetSize())
			If (Winter_ExposureArmorLists_dyn.GetAt(i) as FormList).HasForm(akArmor)
				return True
			EndIf
			i += 1
		EndWhile
		return False
	EndIf
EndFunction

int Function GetExposureIndex(Armor akArmor)
	If (akArmor != None)
		int i = 0
		While (i < Winter_ExposureArmorLists_dyn.GetSize())
			If (Winter_ExposureArmorLists_dyn.GetAt(i) as FormList).HasForm(akArmor)
				return i
			EndIf
			i += 1
		EndWhile
		return -1
	EndIf
EndFunction


string Function EntryToString(Form akArmor) Global
	If (akArmor)
		return akArmor.GetName()+":"+akArmor
	Else
		return "Invalid Entry"
	EndIf
EndFunction

Function ChangeArmor(Armor akArmor, int Exposure)
	; Get the index of the Exposure to add
	int CurrentExposureIndex = GetExposureIndex(akArmor)
	int NewExposureIndex = Exposure / 5
	; Find out if it is already in the database and remove it (assuming it is not Vanilla)
	If CurrentExposureIndex > -1
		(Winter_ExposureArmorLists_dyn.GetAt(CurrentExposureIndex) as FormList).RemoveAddedForm(akArmor)
	Endif
	; Add it to the Formlist of choice
	(Winter_ExposureArmorLists_dyn.GetAt(NewExposureIndex) as FormList).AddForm(akArmor)
	Equipment.StartTimer(1.5, 1)
EndFunction

; Methods
;---------------------------------------------

State UpdateState
	Event OnBeginState(String asOldState)
		; Initialize all the of the armors from Winter_ExposureArmorLists to the dynamic version (so they can be added/deleted on demand) 
		int i = 0
		int j = 0
		While i < Winter_ExposureArmorLists.GetSize()
			j = 0
			While j < (Winter_ExposureArmorLists.GetAt(i) as FormList).GetSize()
				(Winter_ExposureArmorLists_dyn.GetAt(i) as FormList).AddForm((Winter_ExposureArmorLists.GetAt(i) as FormList).GetAt(j) as Armor)
				;WriteLine(Log,"			Orig: " + (Winter_ExposureArmorLists.GetAt(i) as FormList).GetAt(j) + " | New:" + (Winter_ExposureArmorLists_dyn.GetAt(i) as FormList).GetAt(j))
				j += 1
			EndWhile
			i += 1
		EndWhile
		Debug.Notification("Database Initalization Finished")
		Equipment.StartTimer(2.5, 1)
		ChangeState(self, EmptyState)
	EndEvent
EndState
