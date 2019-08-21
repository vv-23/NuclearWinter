Scriptname NuclearWinter:Player:Animation extends NuclearWinter:Core:Required
import Shared:Log
import NuclearWinter:Context

UserLog Log


; Vanilla Animations
;string Animation_WeaponFire = "weaponFire" const

; Mask Animations
string Animation_GasMaskStart = "GasMaskStart" const
string Animation_FadeIn = "FadeIn" const
string Animation_FadeOut = "FadeOut" const
string Animation_MaskOff = "MaskOff" const
string Animation_MaskOn = "MaskOn" const
string Animation_FilterOff = "FilterOff" const
string Animation_FilterOn = "FilterOn" const
string Animation_WipeStart = "WipeStart" const
string Animation_WipeEnd = "WipeEnd" const
string Animation_GasMaskEnd = "GasMaskEnd" const


; Events
;---------------------------------------------

Event OnInitialize()
	Log = GetLog(self)
	Log.FileName = "Gear"
EndEvent


Event OnEnable()
	;RegisterForAnimation(self, Player, Animation_WeaponFire, Log)
	RegisterForAnimation(self, Player, Animation_GasMaskStart, Log)
	RegisterForAnimation(self, Player, Animation_FadeIn, Log)
	RegisterForAnimation(self, Player, Animation_FadeOut, Log)
	RegisterForAnimation(self, Player, Animation_MaskOff, Log)
	RegisterForAnimation(self, Player, Animation_MaskOn, Log)
	RegisterForAnimation(self, Player, Animation_FilterOff, Log)
	RegisterForAnimation(self, Player, Animation_FilterOn, Log)
	RegisterForAnimation(self, Player, Animation_WipeStart, Log)
	RegisterForAnimation(self, Player, Animation_WipeEnd, Log)
	RegisterForAnimation(self, Player, Animation_GasMaskEnd, Log)
EndEvent


Event OnDisable()
	UnregisterForAnimationEvent(Player, Animation_GasMaskStart)
	UnregisterForAnimationEvent(Player, Animation_FadeIn)
	UnregisterForAnimationEvent(Player, Animation_FadeOut)
	UnregisterForAnimationEvent(Player, Animation_MaskOff)
	UnregisterForAnimationEvent(Player, Animation_MaskOn)
	UnregisterForAnimationEvent(Player, Animation_FilterOff)
	UnregisterForAnimationEvent(Player, Animation_FilterOn)
	UnregisterForAnimationEvent(Player, Animation_WipeStart)
	UnregisterForAnimationEvent(Player, Animation_WipeEnd)
	UnregisterForAnimationEvent(Player, Animation_GasMaskEnd)
EndEvent


Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	WriteLine(Log, "Animation '"+asEventName+"' from '"+akSource+"'.")

	If (asEventName == Animation_GasMaskStart)
		; The first frame of the draw animation, so it is the start of the whole gas mask animation
		return
	ElseIf (asEventName == Animation_FadeIn)
		; when the IMOD for fade should start
		return
	ElseIf (asEventName == Animation_FadeOut)
		; when the IMOD for fade should end
		return
	ElseIf (asEventName == Animation_MaskOff)
		; when the actual Gas Mask ARMO should be unequiped on player and the glass overlay should be hidden (Reset the screen blood fade to default)
		return
	ElseIf (asEventName == Animation_MaskOn)
		; when the actual Gas Mask ARMO should be equiped on player and the glass overlay should be displayed (Set the screen blood fade to an insanely long time)
		return
	ElseIf (asEventName == Animation_FilterOff)
		; when the counter for filter should stop and reset to the fresh filter value
		return
	ElseIf (asEventName == Animation_FilterOn)
		; when the counter for filter should start again
		return
	ElseIf (asEventName == Animation_WipeStart)
		; when the players hand is at the left edge of the screen (values for screen blood should be set to ~ less than a 0,5 second fade value)
		return
	ElseIf (asEventName == Animation_WipeEnd)
		; when the hand is done wiping the glass (screen blood value should be again set to infinite)
		return
	ElseIf (asEventName == Animation_GasMaskEnd)
		; The last frame of the withdraw animation, so it is the end of the whole gas mask animation
		return
	Else
		; unhandled event
		return
	EndIf
EndEvent


Event OnAnimationEventUnregistered(ObjectReference akSource, string asEventName)
	WriteLine(Log, "Animation Unregistered: '"+asEventName+"'")
EndEvent


; Globals
;---------------------------------------------

bool Function RegisterForAnimation(ScriptObject aObject, ObjectReference akSender, string asEventName, UserLog aLog = none) Global
	If (aObject)
		If (akSender)
			If (aObject.RegisterForAnimationEvent(akSender, asEventName))
				WriteLine(aLog, "The animation event '"+asEventName+"' on '"+akSender+"' has been registered for '"+aObject+"'.")
				return true
			Else
				WriteLine(aLog, "The animation event '"+asEventName+"' on '"+akSender+"' could not be registered for '"+aObject+"'.")
				return false
			EndIf
		Else
			WriteLine(aLog, "Cannot register for animation events with a none sender.")
			return false
		EndIf
	Else
		WriteLine(aLog, "Cannot register for animation events with a none script object.")
		return false
	EndIf
EndFunction


bool Function IdlePlay(Actor akActor, Idle akIdle, UserLog aLog = none) Global
	If (akActor)
		If (akIdle)
			If (akActor.PlayIdle(akIdle))
				WriteLine(aLog, "Played the '"+akIdle+"' idle animation on the '"+akActor+"' actor.")
				return true
			Else
				WriteLine(aLog, "Something went wrong playing the '"+akIdle+"' idle animation on the '"+akActor+"' actor.")
				return false
			EndIf
		Else
			WriteLine(aLog, "Cannot play a none idle animation for the '"+akActor+"' actor.")
			return false
		EndIf
	Else
		WriteLine(aLog, "Cannot play an idle animation on a none reference.")
		return false
	EndIf
EndFunction
