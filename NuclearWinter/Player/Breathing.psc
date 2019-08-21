Scriptname NuclearWinter:Player:Breathing extends ActiveMagicEffect

import NuclearWinter
import NuclearWinter:Player:Animation
import Shared:Log


int increase = 0
int decrease = 1
int hang = 2
int Breathing_SoundInstance
Actor Player
Sound akSound
UserLog Log

CustomEvent EndedBreathing
CustomEvent StartedBreathing

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Speech"
	WriteLine(Log, "Breathing Started...")
	Player = Game.GetPlayer()
	RegisterForCustomEvent(MaskBreathing, "StopBreathing")
	RegisterForCustomEvent(MaskBreathing, "IncreaseBreathing")
	RegisterForCustomEvent(GearMaskBreathingPreset, "OnChanged")
	akSound = SoundBreathing
	Breathing_SoundInstance = akSound.Play(Player)
	Sound.SetInstanceVolume(Breathing_SoundInstance, CurrentVolume_Breathing.GetValue())
	WriteLine(Log, "Breathing Volume: " + CurrentVolume_Breathing.GetValue())
	CurrentVolume_Breathing.SetValue(0.2)
	StartTimer(0.5, increase)
	StartTimer(2000.0, hang)
EndEvent

Event OnTimer(int aiTimerID)
	If aiTimerID == increase
		Sound.SetInstanceVolume(Breathing_SoundInstance, CurrentVolume_Breathing.GetValue())
		WriteLine(Log, "Breathing Volume: " + CurrentVolume_Breathing.GetValue())
		If CurrentVolume_Breathing.GetValue() < 1.0
			CurrentVolume_Breathing.SetValue(CurrentVolume_Breathing.GetValue() + 0.2)
			StartTimer(0.5, increase)
		EndIf
	ElseIf aiTimerID == decrease
		Sound.SetInstanceVolume(Breathing_SoundInstance, CurrentVolume_Breathing.GetValue())
		WriteLine(Log, "Breathing Volume: " + CurrentVolume_Breathing.GetValue())
		If CurrentVolume_Breathing.GetValue() > 0.0
			CurrentVolume_Breathing.SetValue(CurrentVolume_Breathing.GetValue() - 0.2)
			StartTimer(0.5, decrease)
		ElseIf CurrentVolume_Breathing.GetValue() == 0.0
			Sound.StopInstance(Breathing_SoundInstance)
			Player.DispelSpell(Breathing)
		EndIf
	EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	WriteLine(Log, "Breathing Stopped...")
	CancelTimer(hang)
	SendCustomEvent("EndedBreathing")
	UnregisterForCustomEvent(MaskBreathing, "StopBreathing")
	UnRegisterForCustomEvent(MaskBreathing, "IncreaseBreathing")
	UnregisterForCustomEvent(GearMaskBreathingPreset, "OnChanged")
EndEvent

Function UsePreset(int aiPreset)
	If (aiPreset >= SoundPresetA && aiPreset <= SoundPresetC)
		SoundPreset.SetValue(aiPreset)
	Else
		WriteLine(Log, "Cannot use the out of range audio preset '"+aiPreset+"'.")
	EndIf
EndFunction

Event NuclearWinter:Gear:MaskBreathing.StopBreathing(Gear:MaskBreathing akSender, var[] arguments)
	CancelTimer(increase)
	StartTimer(0.5, decrease)
EndEvent

Event NuclearWinter:Gear:MaskBreathing.IncreaseBreathing(Gear:MaskBreathing akSender, var[] arguments)
	CancelTimer(decrease)
	StartTimer(0.5, increase)
EndEvent

Event NuclearWinter:Terminals:GearMaskBreathingPreset.OnChanged(Terminals:GearMaskBreathingPreset akSender, var[] arguments)
	int preset = (arguments[0] as Int)
	UsePreset(preset)
	Sound.StopInstance(Breathing_SoundInstance)
	WriteLine(Log, "Changed Preset: Started Breathing...")
	Utility.Wait(1.0)
	Breathing_SoundInstance = akSound.Play(Player)
	If (Mask.IsGasMask || Mask.IsPowerArmor)
		Sound.SetInstanceVolume(Breathing_SoundInstance, CurrentVolume_Breathing.GetValue())
	EndIf
EndEvent



; Properties
;---------------------------------------------

Group Properties
	Sound Property NuclearWinter_DummySound Auto Const 
	Sound Property NuclearWinter_GearBreathingSFX_STD Auto Const Mandatory
	Sound Property NuclearWinter_GearBreathingSFX_Alt1 Auto Const Mandatory
	Sound Property NuclearWinter_GearBreathingSFX_Alt2 Auto Const Mandatory
	Sound Property NuclearWinter_GearBreathingSFX_FemaleAlt3 Auto Const Mandatory
	Spell Property Breathing Auto Const Mandatory
	GlobalVariable Property SoundPreset Auto Mandatory
	GlobalVariable Property CurrentVolume_Breathing Auto Mandatory
	Terminals:GearMaskBreathingPreset Property GearMaskBreathingPreset Auto Const Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:MaskBreathing Property MaskBreathing Auto Const Mandatory
EndGroup

Group Sounds
	int Property SoundPresetA = 2 AutoReadOnly
	int Property SoundPresetB = 3 AutoReadOnly
	int Property SoundPresetC = 4 AutoReadOnly
	int Property SoundPresetD = 5 AutoReadOnly

	Sound Property SoundBreathing Hidden
		Sound Function Get()
			If (SoundPreset.GetValue() == SoundPresetA)
				return NuclearWinter_GearBreathingSFX_Alt1
			ElseIf (SoundPreset.GetValue() == SoundPresetB)
				return NuclearWinter_GearBreathingSFX_Alt2
			ElseIf (SoundPreset.GetValue() == SoundPresetD)
				return NuclearWinter_GearBreathingSFX_FemaleAlt3
			ElseIf (SoundPreset.GetValue() == SoundPresetC)
				return NuclearWinter_GearBreathingSFX_STD
			Else
				return NuclearWinter_DummySound
			EndIf
		EndFunction
	EndProperty
EndGroup
