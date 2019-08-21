Scriptname NuclearWinter:Player:SprintingSpell extends ActiveMagicEffect

import NuclearWinter
import NuclearWinter:Player:Animation
import Shared:Log


int increase = 0
int decrease = 1
int hang = 2
int Sprinting_SoundInstance
Actor Player
UserLog Log

CustomEvent EndedSprinting
CustomEvent StartedSprinting

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Speech"
	WriteLine(Log, "Sprinting Started...")
	Player = Game.GetPlayer()
	RegisterForCustomEvent(MaskBreathing, "StopSprinting")
	RegisterForCustomEvent(MaskBreathing, "IncreaseSprinting")
	Sprinting_SoundInstance = NuclearWinter_GearSprintingSFX.Play(Player)
	Sound.SetInstanceVolume(Sprinting_SoundInstance, CurrentVolume_Sprinting.GetValue())
	WriteLine(Log, "Sprinting Volume: " + CurrentVolume_Sprinting.GetValue())
	CurrentVolume_Sprinting.SetValue(0.2)
	StartTimer(0.5, increase)
	StartTimer(2000.0, hang)
EndEvent

Event OnTimer(int aiTimerID)
	If aiTimerID == increase
		Sound.SetInstanceVolume(Sprinting_SoundInstance, CurrentVolume_Sprinting.GetValue())
		WriteLine(Log, "Sprinting Volume: " + CurrentVolume_Sprinting.GetValue())
		If CurrentVolume_Sprinting.GetValue() < 1.0
			CurrentVolume_Sprinting.SetValue(CurrentVolume_Sprinting.GetValue() + 0.2)
			StartTimer(0.5, increase)
		EndIf
	ElseIf aiTimerID == decrease
		Sound.SetInstanceVolume(Sprinting_SoundInstance, CurrentVolume_Sprinting.GetValue())
		If CurrentVolume_Sprinting.GetValue() > 0.0
			CurrentVolume_Sprinting.SetValue(CurrentVolume_Sprinting.GetValue() - 0.2)
			WriteLine(Log, "Sprinting Volume: " + CurrentVolume_Sprinting.GetValue())
			StartTimer(0.5, decrease)
		ElseIf CurrentVolume_Sprinting.GetValue() == 0.0
			Sound.StopInstance(Sprinting_SoundInstance)
			Player.DispelSpell(Sprinting)
		EndIf
	EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	WriteLine(Log, "Sprinting Stopped...")
	CancelTimer(hang)
	SendCustomEvent("EndedSprinting")
	UnRegisterForCustomEvent(MaskBreathing, "IncreaseSprinting")
	UnregisterForCustomEvent(MaskBreathing, "StopSprinting")
EndEvent

Event NuclearWinter:Gear:MaskBreathing.StopSprinting(Gear:MaskBreathing akSender, var[] arguments)
	CancelTimer(increase)
	StartTimer(0.5, decrease)
EndEvent

Event NuclearWinter:Gear:MaskBreathing.IncreaseSprinting(Gear:MaskBreathing akSender, var[] arguments)
	CancelTimer(decrease)
	StartTimer(0.5, increase)
EndEvent



; Properties
;---------------------------------------------

Group Properties
	Spell Property Sprinting Auto Const Mandatory
	GlobalVariable Property CurrentVolume_Sprinting Auto Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:MaskBreathing Property MaskBreathing Auto Const Mandatory
	Sound Property NuclearWinter_GearSprintingSFX Auto Const Mandatory
EndGroup

