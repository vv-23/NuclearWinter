Scriptname NuclearWinter:World:BreathEffect extends NuclearWinter:Core:Optional
{QUST:Winter_Context}
import NuclearWinter
import Shared:Log

UserLog Log
VisualEffect Property Winter_Breath1st_VFX Auto
VisualEffect Property Winter_Breath3rd_VFX Auto


int BreathTimer
; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Shader"
EndEvent


Event OnEnable()
	;RegisterForCustomEvent(Climate, "OnWeatherChanged")
	;RegisterForCustomEvent(Thermodynamics, "OnChanged")
	GoToState("ActiveState")
EndEvent


Event OnDisable()
	;UnregisterForCustomEvent(Climate, "OnWeatherChanged")
	;UnRegisterForCustomEvent(Thermodynamics, "OnChanged")
	GoToState("")
EndEvent

Event OnTimer(int aiTimerID)
	If aiTimerID == BreathTimer
		If(Thermodynamics.Temperature < 42.0)
			WriteLine(Log, "Start Breath")
			If(IsFirstPerson)
				Winter_Breath1st_VFX.Play(Player, 2.4)
				Winter_Breath1st_VFX.Play(Player, 2.2)
				Winter_Breath1st_VFX.Play(Player, 2.0)
				Winter_Breath1st_VFX.Play(Player, 1.8)
			Else
				Winter_Breath3rd_VFX.Play(Player, 2.4)
				Winter_Breath3rd_VFX.Play(Player, 2.2)
				Winter_Breath3rd_VFX.Play(Player, 2.0)
				Winter_Breath3rd_VFX.Play(Player, 1.8)
			EndIf
		EndIf
		If Player.IsTalking()
			StartTimer(1,BreathTimer)
			WriteLine(Log, "Player is Talking")
		ElseIf Player.IsSprinting()
			StartTimer(0.7,BreathTimer)
			WriteLine(Log, "Player is Sprinting")
		ElseIf Player.IsInCombat() || Player.IsRunning()
			StartTimer(2.5,BreathTimer)
			WriteLine(Log, "Player is In Combat or Running")
		Else
			StartTimer(4,BreathTimer)
			WriteLine(Log, "Player is Normal")
		EndIf
	EndIf
EndEvent

; Methods
;---------------------------------------------

State ActiveState

	Event OnBeginState(string asOldState)
		StartTimer(3,BreathTimer)
	EndEvent
	
	Event OnEndState(string asNewState)
		CancelTimer(BreathTimer)
	EndEvent

EndState

; Event NuclearWinter:World:Thermodynamics.OnChanged(World:Thermodynamics akSender, var[] arguments)
	; {EMPTY}
; EndEvent


; Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
	; {EMPTY}
; EndEvent


; Properties
;---------------------------------------------
; Function Start()
		; WriteLine(Log, "Start Effect: " + FXS)
; EndFunction


; Function Stop()
		; WriteLine(Log, "Stop Effect:" + FXS)
; EndFunction


; Properties
;---------------------------------------------


Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Player.GetAnimationVariableBool("IsFirstPerson")
		EndFunction
	EndProperty
EndGroup

Group Context
	;World:Climate Property Climate Auto Const Mandatory
	World:Thermodynamics Property Thermodynamics Auto Const Mandatory
	;World:WeatherDatabase Property WeatherDatabase Auto Const Mandatory
EndGroup
