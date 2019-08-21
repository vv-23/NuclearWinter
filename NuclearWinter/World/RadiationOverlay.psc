Scriptname NuclearWinter:World:RadiationOverlay extends NuclearWinter:Core:Optional
import NuclearWinter
import Shared:Log

UserLog Log

ImageSpaceModifier FX
int ExposureStrength = 1 const


; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Radiation"
	FX = NuclearWinter_RadiationScreenFX
EndEvent


; Methods
;---------------------------------------------

State ActiveState
	Event OnBeginState(string asOldState)
		RegisterForCustomEvent(Radiation, "OnChanged")
		RegisterForCustomEvent(Filter, "OnReplaced")
	EndEvent


	Event NuclearWinter:World:Radiation.OnChanged(World:Radiation akSender, var[] arguments)
		WriteLine(Log, "The player radiation has changed.")

		If (Radiation.Threshold)
				ScreenFX.Remove()
				ScreenFX.Apply(ExposureStrength)
				WriteLine(Log, "Radiation.OnChanged Applying the exposure overlay IMOD with stength "+ExposureStrength)
				Speech.Play(NuclearWinter_GearChokingSFX)
		Else
			If(Mask.IsGasMask)
				Speech.Play(MaskBreathing.SoundBreathing)
			EndIf
			ScreenFX.Remove()
			WriteLine(Log, "The world radiation has not reached its hazard threshold.")
		EndIf

	EndEvent

	Event NuclearWinter:Gear:Filter.OnReplaced(Gear:Filter akSender, var[] arguments)
		Speech.Play(MaskBreathing.SoundBreathing)
	EndEvent


	Event OnEndState(string asNewState)
		UnregisterForCustomEvent(Radiation, "OnChanged")
		UnregisterForCustomEvent(Filter, "OnReplaced")
	EndEvent
EndState



Event NuclearWinter:World:Radiation.OnChanged(World:Radiation akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:Gear:Filter.OnReplaced(Gear:Filter akSender, var[] arguments)
	{EMPTY}
EndEvent

; Properties
;---------------------------------------------

Group Context
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:MaskBreathing Property MaskBreathing Auto Const Mandatory
	Gear:Filter Property Filter Auto Const Mandatory
	Player:Speech Property Speech Auto Const Mandatory
	World:Radiation Property Radiation Auto Const Mandatory
EndGroup

Group Properties
	ImageSpaceModifier Property NuclearWinter_RadiationScreenFX Auto Const Mandatory
	Sound Property NuclearWinter_GearChokingSFX Auto Const Mandatory
EndGroup

Group Overlays
	ImageSpaceModifier Property ScreenFX Hidden
		ImageSpaceModifier Function Get()
			return FX
		EndFunction
		Function Set(ImageSpaceModifier value)
			If (FX != value)
				WriteChangedValue(Log, "ScreenFX", FX, value)
				FX.Remove()
				FX = value
			Else
				WriteLine(Log, "ScreenFX already equals "+value)
			EndIf
		EndFunction
	EndProperty
EndGroup
