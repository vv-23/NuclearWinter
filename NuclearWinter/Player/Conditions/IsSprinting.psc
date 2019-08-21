ScriptName NuclearWinter:Player:Conditions:IsSprinting extends ActiveMagicEffect
import NuclearWinter
import Shared:Log

UserLog Log

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Player"
EndEvent

State Walking

	Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	  If (akSource == Game.GetPlayer()) && (asEventName == "FootSprintLeft")
		WriteLine(Log, "Sprinting Started...")
		Sprinting.InvokeChanged(true)
		UnRegisterForAnimationEvent(Game.GetPlayer(), "FootSprintLeft")
		GoToState("Sprinting")
	  EndIf
	EndEvent
	
EndState

State Sprinting

	Event OnEffectFinish(Actor akTarget, Actor akCaster)
		Sprinting.InvokeChanged(false)
		WriteLine(Log, "Sprinting Stopped...")
		WriteLine(Log, "IsSprinting: OnEffectFinish")
		;GoToState("Walking")
	EndEvent
	
EndState

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForAnimationEvent(Game.GetPlayer(), "FootSprintLeft")
	WriteLine(Log, "IsSprinting: OnEffectStart")
	GoToState("Walking")
EndEvent

	
; Properties
;---------------------------------------------

Group Properties
	Player:Sprinting Property Sprinting Auto Const Mandatory
EndGroup
