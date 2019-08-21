Scriptname NuclearWinter:Gear:DetectRadiators extends NuclearWinter:Core:Optional
import NuclearWinter
import NuclearWinter:Gear
import Shared:Log

UserLog Log

;-- Variables ---------------------------------------

float fTimer = 1.0
int iTimerID = 1
int iRadius = 600

; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_DetectRadiators"
EndEvent

Event OnEnable()
	WriteLine(Log, "Detect Radiators Intialized.")
	Search()
	StartTimer(fTimer, iTimerID)	
EndEvent


Event OnDisable()
	WriteLine(Log, "Detect Radiators Disabled.")
	CancelTimer(iTimerID)
EndEvent

;-- Functions ---------------------------------------

State ActiveState

	Event OnTimer(int aiTimerID)
		If (aiTimerID == iTimerID)
			If (Search())
				If(IsInRadiator == false)
					IsInRadiator = true
					WriteLine(Log, "Entered Radiator range...")
				EndIf
			Else
				If(IsInRadiator)
					IsInRadiator = false
					WriteLine(Log, "Exited Radiator range...")
				EndIf
			EndIf
			StartTimer(fTimer, iTimerID)
		EndIf
	EndEvent
	
EndState

bool Function Search()
	ObjectReference[] RadiatorList
	RadiatorList = Player.FindAllReferencesOfType(Winter_RadiatorList as Form, iRadius as float)
	If (RadiatorList.length)
		return True
	Else
		return False
	EndIf
EndFunction
	
;-- Properties --------------------------------------
bool Property IsInRadiator Auto
FormList Property Winter_RadiatorList Auto Const
