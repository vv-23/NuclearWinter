Scriptname NuclearWinter:World:HeatSource extends NuclearWinter:Core:Optional
import NuclearWinter
import NuclearWinter:Gear
import Shared:Log

CustomEvent OnHeatSourceIn
CustomEvent OnHeatSourceOut

UserLog Log

;-- Variables ---------------------------------------

float fTimer = 1.0
int iTimerID = 1
float RadiusVeryLarge = 1600.0
float RadiusLarge = 300.0
float RadiusMedium = 200.0
float RadiusSmall = 128.0

; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_HeatSource"
EndEvent

Event OnEnable()
	WriteLine(Log, "Heat Source Intialized.")
	SearchHeatSource()
	StartTimer(fTimer, iTimerID)
	GoToState("ActiveState")
EndEvent


Event OnDisable()
	WriteLine(Log, "Heat Source Disabled.")
	CancelTimer(iTimerID)
	GoToState("")
EndEvent

;-- Functions ---------------------------------------

State ActiveState

	Event OnTimer(int aiTimerID)
		If (aiTimerID == iTimerID)
			If (SearchHeatSource())
				If(IsInHeatSource == false)
					IsInHeatSource = true
					SendCustomEvent("OnHeatSourceIn")
					WriteLine(Log, "Entered Heat Source...")
					;Debug.Notification("Entered Heat Source")
				EndIf
			Else
				If(IsInHeatSource)
					IsInHeatSource = false
					SendCustomEvent("OnHeatSourceOut")
					WriteLine(Log, "Exited Heat Source...")
					;Debug.Notification("Exited Heat Source")
				EndIf
			EndIf
			StartTimer(fTimer, iTimerID)
		EndIf
	EndEvent
	
EndState

bool Function SearchHeatSource()
	ObjectReference[] FireList
	FireList = Player.FindAllReferencesOfType(Winter_FireVeryLarge as Form, RadiusVeryLarge)
	If (FireList.length)
		return True
	EndIf
	FireList = Player.FindAllReferencesOfType(Winter_FireLarge as Form, RadiusLarge)
	If (FireList.length)
		return True
	EndIf
	FireList = Player.FindAllReferencesOfType(Winter_FireMedium as Form, RadiusMedium)
	If (FireList.length)
		return True
	EndIf
	FireList = Player.FindAllReferencesOfType(Winter_FireSmall as Form, RadiusSmall)
	If (FireList.length)
		return True
	EndIf
	return false
EndFunction
	
;-- Properties --------------------------------------
bool Property IsInHeatSource Auto
FormList Property Winter_FireVeryLarge Auto Const
FormList Property Winter_FireLarge Auto Const
FormList Property Winter_FireMedium Auto Const
FormList Property Winter_FireSmall Auto Const

