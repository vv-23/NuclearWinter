Scriptname NuclearWinter:Player:Amnesia extends ActiveMagicEffect 

import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log

int TeleportTimer = 0
int TimeScaleTimer = 1
int BlinkTimer = 2
float scale

Activator Property Winter_Marker Auto
Spell Property Winter_SlowTime Auto
Spell Property Winter_FallImmunity Auto
ImageSpaceModifier property Winter_BlinkImod Auto
GlobalVariable Property TimeScale Auto
ObjectReference Marker
Actor Player 

Event OnInIt()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Freezing"
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Player = Game.GetPlayer()
	scale = TimeScale.GetValue()
	;Debug.Notification(TimeScale.GetValue())
	StartTimer(2,BlinkTimer)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	CancelTimer(TeleportTimer)
	If TimeScale.GetValue() != scale
		TimeScale.SetValue(scale)
	EndIf
	If(Marker)
		Marker.Deletewhenable()
        Marker = None
	EndIf
	Player.DispelSpell(Winter_SlowTime)
EndEvent

Event OnTimer(int aiTimerID)

	If aiTimerID == BlinkTimer
		Winter_BlinkImod.Apply(1.0)
		StartTimer(3, TeleportTimer)
	EndIf
	
	If aiTimerID == TeleportTimer
		;scale = TimeScale.GetValue()
		Marker = Player.PlaceAtMe(Winter_Marker as Form, 1)
		Winter_FallImmunity.Cast(Player,Player)
		int direction = Utility.RandomInt(0,3)
		If direction == 0
			Player.MoveTo(Marker as ObjectReference, Utility.RandomFloat(8000.0, 30000.0), Utility.RandomFloat(8000.0, 30000.0), 0, true)
		ElseIf direction == 1
			Player.MoveTo(Marker as ObjectReference, Utility.RandomFloat(-8000.0, -30000.0), Utility.RandomFloat(8000.0, 30000.0), 0, true)
		ElseIf direction == 2
			Player.MoveTo(Marker as ObjectReference, Utility.RandomFloat(-8000.0, -30000.0), Utility.RandomFloat(-8000.0, -30000.0), 0, true)
		ElseIf direction == 3
			Player.MoveTo(Marker as ObjectReference, Utility.RandomFloat(8000.0, 30000.0), Utility.RandomFloat(-8000.0, -30000.0), 0, true)
		EndIf
		Utility.wait(0.1)
		Marker.Deletewhenable()
        Marker = None
		Winter_SlowTime.Cast(Player,Player)
		TimeScale.SetValue(2500)
		StartTimer(3, TimeScaleTimer)
		StartTimer(300,TeleportTimer)
	EndIf
	
	If aiTimerId == TimeScaleTimer
		TimeScale.SetValue(scale)
		;Debug.Notification(TimeScale.GetValue())
	EndIf
	
EndEvent
