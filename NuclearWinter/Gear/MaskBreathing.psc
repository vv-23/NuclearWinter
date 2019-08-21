Scriptname NuclearWinter:Gear:MaskBreathing extends NuclearWinter:Core:Optional
{QUST:NuclearWinter_Gear}
import NuclearWinter
import NuclearWinter:Player:Animation
import Shared:Log


UserLog Log

CustomEvent StopBreathing
CustomEvent StopChoking
CustomEvent StopSprinting
CustomEvent StopCoughing

CustomEvent IncreaseBreathing
CustomEvent IncreaseSprinting
CustomEvent	IncreaseChoking
CustomEvent IncreaseCoughing

ImageSpaceModifier FX
int ExposureStrength = 1 const

; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Speech"
	FX = NuclearWinter_RadiationScreenFX
EndEvent


Event OnEnable()
	RegisterForCustomEvent(Mask, "OnChanged")
	RegisterForCustomEvent(SprintingScript, "OnChanged")
	RegisterForCustomEvent(Radiation, "OnChanged")
	RegisterForCustomEvent(Climate, "OnLocationChanged")
	RegisterForCustomEvent(Filter, "OnDegraded")
	RegisterForCustomEvent(Filter, "OnReplaced")
	RegisterForCustomEvent(BreathingScript, "EndedBreathing")
	RegisterForCustomEvent(SprintingSpell, "EndedSprinting")
	RegisterForRemoteEvent(Player, "OnPlayerLoadGame")
	StartBreathing()
EndEvent


Event OnDisable()
	UnregisterForCustomEvent(Mask, "OnChanged")
	UnregisterForCustomEvent(SprintingScript, "OnChanged")
	UnregisterForCustomEvent(Radiation, "OnChanged")
	UnRegisterForCustomEvent(Climate, "OnLocationChanged")
	UnRegisterForCustomEvent(Filter, "OnDegraded")
	UnRegisterForCustomEvent(Filter, "OnReplaced")
	UnRegisterForCustomEvent(BreathingScript, "EndedBreathing")
	UnRegisterForCustomEvent(SprintingSpell, "EndedSprinting")
	UnRegisterForRemoteEvent(Player, "OnPlayerLoadGame")
	;Speech.Stop()
EndEvent


; Methods
;---------------------------------------------

State ActiveState

	Event Actor.OnPlayerLoadGame(Actor akPlayer)
		Utility.wait(2)
		WriteLine(Log, "MaskBreathing: OnPlayerLoadGame")
		StartBreathing()
	EndEvent
	
	Event NuclearWinter:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
		WriteLine(Log, "MaskBreathing: Mask.OnChanged")
		; Might need to add Stop() here
		If ((Mask.IsGasMask || Mask.IsPowerArmor) && Radiation.isPastThreshold == false)
			If (Filter.Charge > 20)
				WriteLine(Log, "Started Breathing...")
				GasMask_Breathing_Spell.Cast(Player, Player)
			ElseIf ((Radiation.WeatherOnly && Climate.WeatherBad) || (Radiation.RadWeatherOnly && Climate.RadWeatherBad) || (Radiation.WeatherOnly == false && Radiation.RadWeatherOnly == false))
				;Speech.ChangeInstanceVolume(0.0, 0.0, 0.0, 1.0)
				NuclearWinter_ChoughingScreenFX.Apply(1.0)
				;coughing = true
			EndIf
		Else
			NuclearWinter_ChoughingScreenFX.Remove()
			SendCustomEvent("StopBreathing")
			;Speech.InstantChange(2)
		EndIf
	EndEvent


	Event NuclearWinter:Player:Sprinting.OnChanged(Player:Sprinting akSender, var[] arguments)
		WriteLine(Log, "MaskBreathing: Sprinting.OnChanged")
		bool bSprinting = arguments[0]
		WriteLine(Log, "bSprinting = " + bSprinting)
		If (Mask.IsGasMask || Mask.IsPowerArmor)
			Utility.wait(1.0)
			;{Breathing, Sprinting, Choking, Coughing}
			If(Player.IsSprinting())
				WriteLine(Log, "Started Sprint Sound...")
				QueueNext(false,qSprinting,false,false)
			ElseIf(choking)
				QueueNext(false,false,qChoking,false)
			ElseIf(coughing)
				QueueNext(false,false,false,qCoughing)
			Else
				QueueNext(qBreathing,false,false,false)
			EndIf
		EndIf
	EndEvent
	
	Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		WriteLine(Log, "Weather Changed...")
		If (Mask.IsGasMask && Mask.IsPowerArmor == false)
		WriteLine(Log, "OnDegraded: " + Filter.Charge)
			If (Filter.Charge <= 20.0) && (coughing == false) && (Player.IsInInterior() == false)
				If ((Radiation.WeatherOnly && Climate.WeatherBad) || (Radiation.RadWeatherOnly && Climate.RadWeatherBad) || (Radiation.WeatherOnly == false && Radiation.RadWeatherOnly == false))
					Utility.wait(1.0)
					SendCustomEvent("StopBreathing") ; Activating Coughing
					WriteLine(Log, "Started Coughing...")
					;coughing = true
					NuclearWinter_ChoughingScreenFX.Apply(1.0)
				EndIf
			ElseIf (Filter.Charge > 20.0) && coughing
				WriteLine(Log, "Stopped Coughing...")
				DeactivateCoughing() 							; Activating GasMask_Breathing_Spell
			EndIf
		EndIf
	EndEvent
	
	Event NuclearWinter:World:Radiation.OnChanged(World:Radiation akSender, var[] arguments)
		WriteLine(Log, "isPastThreshold = " + Radiation.isPastThreshold)
		If (Radiation.isPastThreshold)
				ScreenFX.Remove()
				Utility.wait(0.2)
				ScreenFX.Apply(ExposureStrength)
				WriteLine(Log, "Radiation.OnChanged | Threshold True | Applying Radiation IMOD")
				If(choking == false)
					;Speech.InstantChange(1) ; Instantly change to choking
					;choking = true
				EndIf
		ElseIf choking == true
			DeactivateChoking()
		EndIf
	EndEvent
	
	Event NuclearWinter:Gear:Filter.OnDegraded(Gear:Filter akSender, var[] arguments)
		If (Mask.IsGasMask && Mask.IsPowerArmor == false)
		WriteLine(Log, "OnDegraded: " + Filter.Charge)
			If (Filter.Charge <= 20.0) && (coughing == false) && (Player.IsInInterior() == false)
				If ((Radiation.WeatherOnly && Climate.WeatherBad) || (Radiation.RadWeatherOnly && Climate.RadWeatherBad) || (Radiation.WeatherOnly == false && Radiation.RadWeatherOnly == false))
					Utility.wait(1.0)
					;Speech.ChangeInstanceVolume(0.0, 0.0, 0.0, 1.0) ; Activating Coughing
					WriteLine(Log, "Started Coughing...")
					;coughing = true
					NuclearWinter_ChoughingScreenFX.Apply(1.0)
				EndIf
			ElseIf (Filter.Charge > 20.0) && coughing
				WriteLine(Log, "Stopped Coughing...")
				DeactivateCoughing() 							; Activating Breathing
			EndIf
		EndIf
	EndEvent
	
	Event NuclearWinter:Gear:Filter.OnReplaced(Gear:Filter akSender, var[] arguments)
			;If(coughing)
				DeactivateCoughing()
			;Endif
	EndEvent
	
	Event NuclearWinter:Player:Breathing.EndedBreathing(Player:Breathing akSender, var[] arguments)
			WriteLine(Log, "Breathing Ended...")
			If(nSprinting)
				StartNext(false,nSprinting,false,false)
				nSprinting = false
			ElseIf(nChoking)
				StartNext(false,false,nChoking,false)
				nChoking = false
			ElseIf(nCoughing)
				StartNext(false,false,false,nCoughing)
				nCoughing = false
			EndIf
	EndEvent
	
	Event NuclearWinter:Player:SprintingSpell.EndedSprinting(Player:SprintingSpell akSender, var[] arguments)
			WriteLine(Log, "Sprinting Ended...")
			If(nSprinting)
				StartNext(false,nSprinting,false,false)
				nSprinting = false
			ElseIf(nChoking)
				StartNext(false,false,nChoking,false)
				nChoking = false
			ElseIf(nCoughing)
				StartNext(false,false,false,nCoughing)
				nCoughing = false
			EndIf
	EndEvent
	
	
	
EndState

Event NuclearWinter:Player:Sprinting.OnChanged(Player:Sprinting akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:World:Radiation.OnChanged(World:Radiation akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:Gear:Filter.OnDegraded(Gear:Filter akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:Gear:Filter.OnReplaced(Gear:Filter akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:Player:Breathing.EndedBreathing(Player:Breathing akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:Player:SprintingSpell.EndedSprinting(Player:SprintingSpell akSender, var[] arguments)
	{EMPTY}
EndEvent

Event Actor.OnPlayerLoadGame(Actor akPlayer)
	{EMPTY}
EndEvent


; Functions
;---------------------------------------------

Function StartBreathing()
	;Speech.Stop()
	Utility.wait(1.0)
	;Speech.Play(SoundBreathing)
	If ((Mask.IsGasMask || Mask.IsPowerArmor) && Radiation.isPastThreshold == false)
		If (Filter.Charge > 20)
			WriteLine(Log, "Started Breathing...")
			GasMask_Breathing_Spell.Cast(Player, Player)
		Else
			;Speech.ChangeInstanceVolume(0.0, 0.0, 0.0, 1.0)
			NuclearWinter_ChoughingScreenFX.Apply(1.0)
			;coughing = true
		EndIf
	Else
		;Speech.InstantChange(2)
	EndIf
EndFunction

Function DeactivateChoking()
	If(Mask.IsGasMask)
		Utility.wait(1.0)
		QueueNext(qBreathing,false,false,false)
	Else
		;Speech.ChangeInstanceVolumeNone()
	EndIf
	;choking = false
	WriteLine(Log, "Radiation.OnChanged | DeactivateChoking | Removing Radiation IMOD")
	ScreenFX.Remove()
EndFunction

Function DeactivateCoughing()
	;Utility.wait(1.0)
	QueueNext(qBreathing,false,false,false)
	NuclearWinter_ChoughingScreenFX.Remove()
	;coughing = false
EndFunction

Function QueueNext(bool qkBreathing, bool qkSprinting, bool qkChoking, bool qkCoughing)
	WriteLine(Log, "Queueing Next: " + qkBreathing + " | " + qkSprinting + " | " + qkChoking + " | " + qkCoughing)
	If qkBreathing
		If sprinting
			SendCustomEvent("StopSprinting")
			nSprinting = false
			nBreathing = true
		ElseIf choking
			SendCustomEvent("StopChoking")
			nChoking = false
			nBreathing = true
		ElseIf coughing
			SendCustomEvent("StopCoughing")
			nCoughing = false
			nBreathing = true
		ElseIf CurrentVolume_Breathing.GetValue() < 1.0 && breathing
			SendCustomEvent("IncreaseBreathing")
		ElseIf breathing == false
			StartNext(sBreathing,false,false,false)
		EndIf
	ElseIf qkSprinting
		If breathing
			SendCustomEvent("StopBreathing")
			nBreathing = false
			nSprinting = true
		ElseIf choking
			SendCustomEvent("StopChoking")
			nChoking = false
			nSprinting = true
		ElseIf coughing
			SendCustomEvent("StopCoughing")
			nCoughing = false
			nSprinting = true
		ElseIf CurrentVolume_Sprinting.GetValue() < 1.0 && sprinting
			SendCustomEvent("IncreaseSprinting")
		ElseIf sprinting == false
			StartNext(false,sSprinting,false,false)
		EndIf
	ElseIf qkChoking
		If breathing
			SendCustomEvent("StopBreathing")
			nBreathing = false
			nChoking = true
		ElseIf sprinting
			SendCustomEvent("StopSprinting")
			nSprinting = false
			nChoking = true
		ElseIf coughing
			SendCustomEvent("StopCoughing")
			nCoughing = false
			nChoking = true
		ElseIf CurrentVolume_Choking.GetValue() < 1.0 && choking
			SendCustomEvent("IncreaseChoking")
		ElseIf choking == false
			StartNext(false,false,sChoking,false)
		EndIf
	ElseIf	qkCoughing
		If breathing
			SendCustomEvent("StopBreathing")
			nBreathing = false
			nCoughing = true
		ElseIf sprinting
			SendCustomEvent("StopSprinting")
			nSprinting = false
			nCoughing = true
		ElseIf choking
			SendCustomEvent("StopChoking")
			nChoking = false
			nCoughing = true
		ElseIf CurrentVolume_Coughing.GetValue() < 1.0 && coughing
			SendCustomEvent("IncreaseCoughing")
		ElseIf coughing == false
			StartNext(false,false,false,sCoughing)
		EndIf
	EndIf
EndFunction

Function EndAll()
	If breathing
		SendCustomEvent("StopBreathing")
	EndIf
	If sprinting
		SendCustomEvent("StopSprinting")
	EndIf
	If choking
		SendCustomEvent("StopChoking")
	EndIf
	If coughing
		SendCustomEvent("StopCoughing")
	EndIf
EndFunction

;After a transition has finished ie: CurrentVolumeX == 0.0 for all sounds, start the next sound
Function StartNext(bool sBreathing, bool sSprinting, bool sChoking, bool sCoughing)
	If sBreathing
		GasMask_Breathing_Spell.Cast(Player, Player)
	ElseIf sSprinting
		GasMask_Sprinting_Spell.Cast(Player, Player)
	ElseIf sChoking
		;GasMask_Choking_Spell.Cast(Player, Player)
	ElseIf sCoughing
		;GasMask_Coughing_Spell.Cast(Player, Player)
	EndIf
EndFunction
	

; Properties
;---------------------------------------------

Group Context
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:Filter Property Filter Auto Const Mandatory
	World:Radiation Property Radiation Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory
	Player:Sprinting Property SprintingScript Auto Const Mandatory
	Player:Breathing Property BreathingScript Auto Const
	Player:SprintingSpell Property SprintingSpell Auto Const
	;Player:Choking Property ChokingScript Auto Const Mandatory
	;Player:Coughing Property CoughingScript Auto Const Mandatory
EndGroup


Group Properties
	ImageSpaceModifier Property NuclearWinter_RadiationScreenFX Auto Const Mandatory
	ImageSpaceModifier Property NuclearWinter_ChoughingScreenFX Auto
	Sound Property NuclearWinter_GearGaspingSFX Auto Const Mandatory
	Sound Property NuclearWinter_GearChokingSFX Auto Const Mandatory
	
	;Spell Property GasMask_Choking_Spell Auto Const Mandatory
	;Spell Property GasMask_Coughing_Spell Auto Const Mandatory
	Spell Property GasMask_Breathing_Spell Auto Const Mandatory
	Spell Property GasMask_Sprinting_Spell Auto Const Mandatory
	
	;Current Status of Player speech
	bool Property choking Hidden
		bool Function Get()
			If Player.HasMagicEffect(GasMask_Player_Choking_Effect)
				return true
			Else
				return false
			EndIf
		EndFunction
	EndProperty
	
	bool Property coughing Hidden
		bool Function Get()
			If Player.HasMagicEffect(GasMask_Player_Coughing_Effect)
				return true
			Else
				return false
			EndIf
		EndFunction
	EndProperty
	
	bool Property breathing Hidden
		bool Function Get()
			If Player.HasMagicEffect(GasMask_Player_Breathing_Effect)
				return true
			Else
				return false
			EndIf
		EndFunction
	EndProperty
	
	bool Property sprinting Hidden
		bool Function Get()
			If Player.HasMagicEffect(GasMask_Player_Sprinting_Effect)
				return true
			Else
				return false
			EndIf
		EndFunction
	EndProperty
	
	;Queue Sound Boolean Variables
	bool Property qBreathing = true Auto Const Hidden
	bool Property qSprinting = true Auto Const Hidden
	bool Property qCoughing = true Auto Const Hidden
	bool property qChoking = true Auto Const Hidden
	
	;Start Sound Boolean Variables
	bool Property sBreathing = true Auto Const Hidden
	bool Property sSprinting = true Auto Const Hidden
	bool Property sCoughing = true Auto Const Hidden
	bool property sChoking = true Auto Const Hidden
	
	;Next Sound Boolean Variables
	bool Property nBreathing = false Auto Hidden
	bool Property nSprinting = false Auto Hidden
	bool Property nCoughing = false Auto Hidden
	bool Property nChoking = false Auto Hidden
	
	MagicEffect Property GasMask_Player_Breathing_Effect Auto Const Mandatory
	MagicEffect Property GasMask_Player_Sprinting_Effect Auto Const Mandatory
	MagicEffect Property GasMask_Player_Coughing_Effect Auto Const Mandatory
	MagicEffect Property GasMask_Player_Choking_Effect Auto Const Mandatory
	
	GlobalVariable Property CurrentVolume_Breathing Auto Mandatory
	GlobalVariable Property CurrentVolume_Sprinting Auto Mandatory
	GlobalVariable Property CurrentVolume_Choking Auto Mandatory
	GlobalVariable Property CurrentVolume_Coughing Auto Mandatory
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
