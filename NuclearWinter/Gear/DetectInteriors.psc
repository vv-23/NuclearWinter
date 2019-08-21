Scriptname NuclearWinter:Gear:DetectInteriors extends NuclearWinter:Core:Optional
import NuclearWinter
import NuclearWinter:Gear
import Shared:Log

CustomEvent OnEnterInterior
CustomEvent OnExitInterior

UserLog Log

;-- Variables ---------------------------------------

float fTimer = 1.0
int iTimerID = 1
int iRadius = 520

; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_DetectFakeInterior"
EndEvent

Event OnEnable()
	WriteLine(Log, "Detect Interiors Intialized.")
	Search()
	StartTimer(fTimer, iTimerID)	
EndEvent


Event OnDisable()
	WriteLine(Log, "Detect Interiors Disabled.")
	CancelTimer(iTimerID)
EndEvent

;-- Functions ---------------------------------------

State ActiveState

	Event OnTimer(int aiTimerID)
		If (aiTimerID == iTimerID)
			If (Search())
				If(IsInFakeInterior == false)
					IsInFakeInterior = true
					SendCustomEvent("OnEnterInterior")
					WriteLine(Log, "Entered Fake Interior...")
				EndIf
			Else
				If(IsInFakeInterior)
					IsInFakeInterior = false
					SendCustomEvent("OnExitInterior")
					WriteLine(Log, "Exited Fake Interior...")
				EndIf
			EndIf
			StartTimer(fTimer, iTimerID)
		EndIf
	EndEvent
	
EndState

bool Function Search()
	ObjectReference[] FakeIntList
	FakeIntList = Player.FindAllReferencesOfType(Winter_FakeInteriors as Form, iRadius as float)
	If (FakeIntList.length)
		return True
	Else
		return False
	EndIf
EndFunction
	
;-- Properties --------------------------------------
bool Property IsInFakeInterior Auto
FormList Property Winter_FakeInteriors Auto Const

