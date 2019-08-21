Scriptname NuclearWinter:Player:Freezing extends NuclearWinter:Core:Optional
{QUST:Winter_Player}
import NuclearWinter
import NuclearWinter:World
import Shared:Log

CustomEvent OnThresholdChange

UserLog Log
;This script outlines the punishments for reaching core body temp thresholds and staying below them.
;A random condition will be added every 10 minutes when you reach a threshold
;if the player does not increase their body temperature above the threshold.

; Many conditions start a recovery timer when above the Comfortable threshold and eventually are healed.
; However, if the player becomes Cold again within that healing period the condition is reset and must be treated by heating up once more. 

;Chilblains: superficial ulcers of the skin that occur when a predisposed individual is repeatedly exposed to cold
;Frostbite: the freezing and destruction of tissue
;Frostnip: a superficial cooling of tissues without cellular destruction
;Trench foot or immersion foot: a condition caused by repetitive exposure to water at non-freezing temperatures
;==============================================================================================================================
; Warm: 								100.8°F (38.2°C)
; No Penalties + (HC) Bonus to Infection resistance
;
; Comfortable: 							<98.7°F (37.1°C) to 96°F (35.6°C)
; No Penalties
;
; Mild Hypothermia/Cold:				<96°F (35.6°C) to 89.6°F (32°C)
;
; Constant Penalty: - Mild Hypothermia, Reduced Aim (Cold Hands), (HC) Increased chance to catch Infection
; Random Penalty: 
; - Shivering: Lowered Charisma, Agility, Endurance
; - (HC) Increased Metabolism: Hunger increases faster
; - Frostnip (1st Degree Frostbite): Damage to limbs (legs/arms) 20, cannot be reveresed until above temperature threshold.
; - (If Wet) Trench Foot: Reduced movement speed, cannot Sprint.
; - Sweating: Increases wetness by 20%
;
; Moderate Hypothermia/Freezing:		<89.6°F (32°C) to 84.5°F (29.2°C)	
; 
; Constant Penalty: - Moderate Hypothermia, Further Reduced Aim (Cold Hands) Permenant damage to arm/leg condition, cannot be reveresed until above temperature threshold.
; Random Penalty: 
; - Pneumonia: Reduced Endurance, Strength, Increased Infection chance, Permenant damage to chest condition, cannot be reveresed until Comfortable temperature threshold.
; - Gangrene: Deals limb damage on an interval. Originally starts in one limb then spreads. Damage increases the longer the ailment persists.	
; - Chilblains: (HC)Increased Infection chance, susceptibility to cold damage (reduced cryo resist).
; - Frostbite: Complete damage to leg and arm condition, susceptibility to cold damage (reduced cryo resist), Reduced Agility.
; - Confusion: Permenant Damage to head condition, Impaired vision (image space modifier), Lowered Charisma, Intelligence
; - Drowsiness: Impaired vision (image space modifier), reduced strength
;
; Severe Hypothermia/Dying: 			<84.5°F (29.2°C)
; Constant Penalty: - Severe Hypothermia: Stacking Cryo Damage (Increases every 30 seconds), Drowsiness, Cannot equip a weapon, Cannot run
; Random Penalty:
; - Paradoxical Undressing: Unequip all clothing (Connot re-equip until above Freezing Threshold)
; - Amnesia: Teleport the player to a random nearby location
; - (If in an Interior or fake) Terminal Burrowing: If the player sleeps or waits, they die.
;==============================================================================================================================

int HeatThresholdTimer = 0
int PneumoniaTimer = 1
int GangreneTimer = 2
int ChilblainsTimer = 3
int FrostbiteTimer = 4
int ConfusionTimer = 5
int DrowsinessTimer = 6

bool HealingStarted = false

bool hasWarm = false

bool hasMildHypothermia = false
bool hasShivering = false
bool hasIncreasedMetabolism = false
bool hasSweating = false
bool hasFrostnip = false
bool hasTrenchfoot = false

bool hasModerateHypothermia = false
bool hasGangrene = false
bool hasFrostbite = false
bool hasPneumonia = false
bool hasChilblains = false
bool hasConfusion = false
bool hasDrowsiness = false

bool hasSevereHypothermia = false
bool hasParadoxicalUndressing = false
bool hasAmnesia = false
bool hasTerminalBurrowing = false

int button = 0

bool HealingStarted_First = true 
;   Warm----------------------------------------
bool WarmBonus_First = true 
;   Cold----------------------------------------
bool  MildHypothermia_First = true 
bool Shivering_First = true 
bool IncreasedMetabolism_First = true 
bool Frostnip_First = true 
bool TrenchFoot_First = true 
bool Sweating_First = true 
;   Freezing------------------------------------
bool ModerateHypothermia_First = true 
bool Pneumonia_First = true 
bool Gangrene_First = true 
bool Chilblains_First = true 
bool Frostbite_First = true 
bool Confusion_First = true 
bool Drowsiness_First = true 
;   Dying---------------------------------------
bool SevereHypothermia_First = true 
bool ParadoxicalUndressing_First = true 
bool Amnesia_First = true 
bool TerminalBurrowing_First = true 

;======================================Events===================================================

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Freezing"
EndEvent

Event OnEnable()
	SetFreezing(true)
EndEvent


Event OnDisable()
	SetFreezing(false)
EndEvent

Event NuclearWinter:World:Thermodynamics.OnChanged(World:Thermodynamics akSender, var[] arguments)

	If(Thermodynamics.CoreTemperature >= 98.7 && Warm != 1.0) ; Warm
		HandleWarm(true)
		HandleMildHypothermia(false)
		HandleModerateHypothermia(false)
		HandleSevereHypothermia(false)
		Warm = 			1.0
		Comfortable = 	0.0
		Cold =			0.0
		Freezing = 		0.0
		Dying = 		0.0
		CancelTimerGameTime(HeatThresholdTimer)
		StartHealing()
		StartHealingSevere()
		SendCustomEvent("OnThresholdChange")
		WriteLine(Log, "Heat Threshold: " + Warm + " | " + Comfortable + " | " + Cold + " | " + Freezing + " | " + Dying)
	ElseIf(Thermodynamics.CoreTemperature < 98.7 && Thermodynamics.CoreTemperature >= 96.0 && Comfortable != 1.0) ; Comfortable
		HandleWarm(false)
		HandleMildHypothermia(false)
		HandleModerateHypothermia(false)
		HandleSevereHypothermia(false)
		Warm = 			0.0
		Comfortable = 	1.0
		Cold =			0.0
		Freezing = 		0.0
		Dying = 		0.0
		CancelTimerGameTime(HeatThresholdTimer)
		StartHealing()
		StartHealingSevere()
		SendCustomEvent("OnThresholdChange")
		WriteLine(Log, "Heat Threshold: " + Warm + " | " + Comfortable + " | " + Cold + " | " + Freezing + " | " + Dying)
	ElseIf(Thermodynamics.CoreTemperature < 96.0 && Thermodynamics.CoreTemperature >= 89.6 && Cold != 1.0)
		If HealingStarted
			CancelHealTimers()
		EndIf
		HandleWarm(false)
		HandleMildHypothermia(true)
		HandleModerateHypothermia(false)
		HandleSevereHypothermia(false)
		Warm = 			0.0
		Comfortable = 	0.0
		Cold =			1.0
		Freezing = 		0.0
		Dying = 		0.0
		StartTimerGameTime(1,HeatThresholdTimer)
		StartHealingSevere()
		SendCustomEvent("OnThresholdChange")
		WriteLine(Log, "Heat Threshold: " + Warm + " | " + Comfortable + " | " + Cold + " | " + Freezing + " | " + Dying)
	ElseIf(Thermodynamics.CoreTemperature < 89.6 && Thermodynamics.CoreTemperature >= 84.5 && Freezing != 1.0)
		If HealingStarted
			CancelHealTimers()
		EndIf
		HandleWarm(false)
		HandleMildHypothermia(true)
		HandleModerateHypothermia(true)
		HandleSevereHypothermia(false)
		Warm = 			0.0
		Comfortable = 	0.0
		Cold =			0.0
		Freezing = 		1.0
		Dying = 		0.0
		StartTimerGameTime(0.8,HeatThresholdTimer)
		StartHealingSevere()
		SendCustomEvent("OnThresholdChange")
		WriteLine(Log, "Heat Threshold: " + Warm + " | " + Comfortable + " | " + Cold + " | " + Freezing + " | " + Dying)
	ElseIf(Thermodynamics.CoreTemperature < 84.5 && Dying != 1.0)
		If HealingStarted
			CancelHealTimers()
		EndIf
		HandleWarm(false)
		HandleMildHypothermia(true)
		HandleModerateHypothermia(true)
		HandleSevereHypothermia(true)
		Warm = 			0.0
		Comfortable = 	0.0
		Cold =			0.0
		Freezing = 		0.0
		Dying = 		1.0
		StartTimerGameTime(0.1,HeatThresholdTimer)
		SendCustomEvent("OnThresholdChange")
		WriteLine(Log, "Heat Threshold: " + Warm + " | " + Comfortable + " | " + Cold + " | " + Freezing + " | " + Dying)
	EndIf
EndEvent

Event OnTimerGameTime(int aiTimerID)
	If(aiTimerID == HeatThresholdTimer)
		If Warm == 1.0
			; DO NOTHING
		ElseIf Comfortable == 1.0
			; DO NOTHING
		ElseIf Cold == 1.0
			RandColdCondition()
		ElseIf Freezing == 1.0
			RandFreezingCondition()
		ElseIf Dying == 1.0
			RandDyingCondition()
		Endif
	EndIf
	If HealingStarted
		If(aiTimerID == PneumoniaTimer)
			Winter_Dispel_Pneumonia_Spell.Cast(Player,Player)
			Player.RemovePerk(Winter_Freezing_Pneumonia)
			Winter_Freezing_Pneumonia_Recovered.Show()
			hasPneumonia = false
			WriteLine(Log, "Pneumonia Healed")
		EndIf
		
		If(aiTimerId == GangreneTimer)
			Winter_Dispel_Gangrene_Spell.Cast(Player,Player)
			Player.RemovePerk(Winter_Freezing_Gangrene)
			Winter_Freezing_Gangrene_Recovered.Show()
			hasGangrene = false
			WriteLine(Log, "Gangrene Healed")
		EndIf
		
		If(aiTimerId == FrostbiteTimer)
			Winter_Dispel_Frostbite_Spell.Cast(Player,Player)
			Player.RemovePerk(Winter_Freezing_Frostbite)
			Winter_Freezing_Frostbite_Recovered.Show()
			hasFrostbite = false
			WriteLine(Log, "Frostbite Healed")
		EndIf
		
		If(aiTimerId == ChilblainsTimer)
			Winter_Dispel_Chilblains_Spell.Cast(Player,Player)
			Player.RemovePerk(Winter_Freezing_Chilblains)
			Winter_Freezing_Chilblains_Recovered.Show()
			hasChilblains = false
			WriteLine(Log, "Chilblains Healed")
		EndIf
		
		If(aiTimerId == DrowsinessTimer)
			Winter_Dispel_Drowsiness_Spell.Cast(Player,Player)
			Player.RemovePerk(Winter_Freezing_Drowsiness)
			Winter_Freezing_Drowsiness_Recovered.Show()
			hasDrowsiness = false
			WriteLine(Log, "Drowsiness Healed")
		EndIf
		
		If(aiTimerId == ConfusionTimer)
			Winter_Dispel_Confusion_Spell.Cast(Player,Player)
			Player.RemovePerk(Winter_Freezing_Confusion)
			Winter_Freezing_Confusion_Recovered.Show()
			hasConfusion = false
			WriteLine(Log, "Confusion Healed")
		EndIf
	EndIf
EndEvent

;======================================Functions==================================================

Function RandColdCondition()
	int Condition = Utility.RandomInt(0, 4)
	
	If(Condition == 0)
		If(!hasShivering)
			Player.EquipItem(Winter_Cold_Shivering_Description, abSilent = true)
			Player.AddPerk(Winter_Cold_Shivering)
			Winter_Cold_Shivering_Gained.Show()
			If(Shivering_First)
				button = Winter_Cold_Shivering_First.Show()
				If button == 1
					Shivering_First = false
				EndIf
			EndIf
			hasShivering = true
			WriteLine(Log, "Gained Shivering")
		Else
			Condition = 1
		EndIf
	EndIf
	If(Condition == 1)
		If(!hasIncreasedMetabolism)
			Player.EquipItem(Winter_Cold_IncreasedMetabolism_Description, abSilent = true)
			Player.AddPerk(Winter_Cold_IncreasedMetabolism)
			Winter_Cold_IncreasedMetabolism_Gained.Show()
			If(IncreasedMetabolism_First)
				button = Winter_Cold_IncreasedMetabolism_First.Show()
				If button == 1
					IncreasedMetabolism_First = false
				EndIf
			EndIf
			hasIncreasedMetabolism = true
			WriteLine(Log, "Gained Increased Metabolism")
		Else
			Condition = 2
		EndIf
	EndIf
	If(Condition == 2)
		If(!hasFrostnip)
			Player.AddPerk(Winter_Cold_Frostnip)
			Winter_Cold_Frostnip_Gained.Show()
			If(Frostnip_First)
				button = Winter_Cold_Frostnip_First.Show()
				If button == 1
					Frostnip_First = false
				EndIf
			EndIf
			hasFrostnip = true
			WriteLine(Log, "Gained Frostnip")
		Else
			Condition = 3
		EndIf
	EndIf
	If(Condition == 3)
		If(!hasTrenchfoot && Thermodynamics.Wetness > 1.0)
			Player.EquipItem(Winter_Cold_TrenchFoot_Description, abSilent = true)
			Player.AddPerk(Winter_Cold_TrenchFoot)
			Winter_Cold_TrenchFoot_Gained.Show()
			If(TrenchFoot_First)
				button = Winter_Cold_TrenchFoot_First.Show()
				If button == 1
					TrenchFoot_First = false
				EndIf
			EndIf
			hasTrenchfoot = true
			WriteLine(Log, "Gained Trenchfoot")
		Else
			Condition = 4
		EndIf
	EndIf
	If(Condition == 4)
		If(!hasSweating)
			Winter_Cold_Sweating_Gained.Show()
			If(Sweating_First)
				button = Winter_Cold_Sweating_First.Show()
				If button == 1
					Sweating_First = false
				EndIf
			EndIf
			Thermodynamics.Wetness = Thermodynamics.Wetness + 0.2
			If Thermodynamics.Wetness > 1.7
				Thermodynamics.Wetness = 1.7
			EndIf
			hasSweating = true
			WriteLine(Log, "Gained Sweating")
		EndIf
	EndIf
	StartTimerGameTime(Utility.RandomInt(3, 5),HeatThresholdTimer)
EndFunction

Function RandFreezingCondition()
	int Condition = Utility.RandomInt(0, 5)
	
	If(Condition == 0)
		If(!hasPneumonia)
			Player.EquipItem(Winter_Freezing_Pneumonia_Description, abSilent = true)
			Player.AddPerk(Winter_Freezing_Pneumonia)
			Winter_Freezing_Pneumonia_Gained.Show()
			If(Pneumonia_First)
				button = Winter_Freezing_Pneumonia_First.Show()
				If button == 1
					Pneumonia_First = false
				EndIf
			EndIf
			hasPneumonia = true
			WriteLine(Log, "Gained Pneumonia")
		Else
			Condition = 1
		EndIf
	EndIf
	If(Condition == 1)
		If(!hasGangrene)
			Player.EquipItem(Winter_Freezing_Gangrene_Description, abSilent = true)
			Player.AddPerk(Winter_Freezing_Gangrene)
			Winter_Freezing_Gangrene_Gained.Show()
			If(Gangrene_First)
				button = Winter_Freezing_Gangrene_First.Show()
				If button == 1
					Gangrene_First = false
				EndIf
			EndIf
			hasGangrene = true
			WriteLine(Log, "Gained Gangrene")
		Else
			Condition = 2
		EndIf
	EndIf
	If(Condition == 2)
		If(!hasChilblains)
			Player.EquipItem(Winter_Freezing_Chilblains_Description, abSilent = true)
			Player.AddPerk(Winter_Freezing_Chilblains)
			Winter_Freezing_Chilblains_Gained.Show()
			If(Chilblains_First)
				button = Winter_Freezing_Chilblains_First.Show()
				If button == 1
					Chilblains_First = false
				EndIf
			EndIf
			hasChilblains = true
			WriteLine(Log, "Gained Chilblains")
		Else
			Condition = 3
		EndIf
	EndIf
	If(Condition == 3)
		If(!hasFrostbite)
			Player.EquipItem(Winter_Freezing_Frostbite_Description, abSilent = true)
			Player.AddPerk(Winter_Freezing_Frostbite)
			Winter_Freezing_Frostbite_Gained.Show()
			If(Frostbite_First)
				button = Winter_Freezing_Frostbite_First.Show()
				If button == 1
					Frostbite_First = false
				EndIf
			EndIf
			hasFrostbite = true
			WriteLine(Log, "Gained Frostbite")
		Else
			Condition = 4
		EndIf
	EndIf
	If(Condition == 4)
		If(!hasConfusion)
			Player.EquipItem(Winter_Freezing_Confusion_Description, abSilent = true)
			Player.AddPerk(Winter_Freezing_Confusion)
			Winter_Freezing_Confusion_Gained.Show()
			If(Confusion_First)
				button = Winter_Freezing_Confusion_First.Show()
				If button == 1
					Confusion_First = false
				EndIf
			EndIf
			hasConfusion = true
			WriteLine(Log, "Gained Confusion")
		Else
			Condition = 5
		EndIf
	EndIf
	If(Condition == 5)
		If(!hasDrowsiness)
			Player.EquipItem(Winter_Freezing_Drowsiness_Description, abSilent = true)
			Player.AddPerk(Winter_Freezing_Drowsiness)
			Winter_Freezing_Drowsiness_Gained.Show()
			If(Drowsiness_First)
				button = Winter_Freezing_Drowsiness_First.Show()
				If button == 1
					Drowsiness_First = false
				EndIf
			EndIf
			hasDrowsiness = true
			WriteLine(Log, "Gained Drowsiness")
		EndIf
	EndIf
	StartTimerGameTime(Utility.RandomInt(3, 5),HeatThresholdTimer)
EndFunction

Function RandDyingCondition()
	int Condition = Utility.RandomInt(0, 2)
	
	If(Condition == 0)
		If(!hasParadoxicalUndressing)
			Player.EquipItem(Winter_Dying_ParadoxicalUndressing_Description, abSilent = true)
			Player.AddPerk(Winter_Dying_ParadoxicalUndressing)
			Winter_Dying_ParadoxicalUndressing_Gained.Show()
			If(ParadoxicalUndressing_First)
				button = Winter_Dying_ParadoxicalUndressing_First.Show()
				If button == 1
					ParadoxicalUndressing_First = false
				EndIf
			EndIf
			hasParadoxicalUndressing = true
			WriteLine(Log, "Gained Paradoxical Undressing")
		Else
			Condition = 1
		EndIf
	EndIf
	If(Condition == 1)
		If(!hasAmnesia)
			Player.EquipItem(Winter_Dying_Amnesia_Description, abSilent = true)
			Player.AddPerk(Winter_Dying_Amnesia)
			Winter_Dying_Amnesia_Gained.Show()
			If(Amnesia_First)
				button = Winter_Dying_Amnesia_First.Show()
				If button == 1
					Amnesia_First = false
				EndIf
			EndIf
			hasAmnesia = true
			WriteLine(Log, "Gained Amnesia")
		Else
			Condition = 2
		EndIf
	EndIf
	If(Condition == 2)
		If(!hasTerminalBurrowing && (Player.IsInInterior() || DetectInteriors.IsInFakeInterior))
			Player.EquipItem(Winter_Dying_TerminalBurrowing_Description, abSilent = true)
			Player.AddPerk(Winter_Dying_TerminalBurrowing)
			Winter_Dying_TerminalBurrowing_Gained.Show()
			If(TerminalBurrowing_First)
				button = Winter_Dying_TerminalBurrowing_First.Show()
				If button == 1
					TerminalBurrowing_First = false
				EndIf
			EndIf
			hasTerminalBurrowing = true
			WriteLine(Log, "Gained Terminal Burrowing")
		EndIf
	EndIf
	StartTimerGameTime(2,HeatThresholdTimer)
EndFunction

Function StartHealing()
	If !HealingStarted ;Time to heal is in game-hours
		;Winter_Dispel_Cold_Spell.Cast(Player,Player)
		If hasShivering
			Player.RemovePerk(Winter_Cold_Shivering)
			Winter_Cold_Shivering_Recovered.Show()
			hasShivering = false
			WriteLine(Log, "Shivering Healed")
		EndIf
		If hasIncreasedMetabolism
			Player.RemovePerk(Winter_Cold_IncreasedMetabolism)
			Winter_Cold_IncreasedMetabolism_Recovered.Show()
			hasIncreasedMetabolism = false
			WriteLine(Log, "Increased Metabolism Healed")
		EndIf
		If hasTrenchfoot
			Player.RemovePerk(Winter_Cold_TrenchFoot)
			Winter_Cold_TrenchFoot_Recovered.Show()
			hasTrenchfoot = false
			WriteLine(Log, "Trenchfoot Healed")
		EndIf
		If hasFrostnip
			Player.RemovePerk(Winter_Cold_Frostnip)
			Winter_Cold_Frostnip_Recovered.Show()
			hasFrostnip = false
			WriteLine(Log, "Frostnip Healed")
		EndIf
		If hasSweating
			hasSweating = false
			WriteLine(Log, "Sweating Healed")
		EndIf
		If hasGangrene
			StartTimerGameTime(24,GangreneTimer)
		EndIf
		If hasFrostbite
			StartTimerGameTime(26,FrostbiteTimer)
		EndIf
		If hasPneumonia
			StartTimerGameTime(22,PneumoniaTimer)
		EndIf
		If hasChilblains
			StartTimerGameTime(18,ChilblainsTimer)
		Endif
		If hasConfusion
			StartTimerGameTime(0.5,ConfusionTimer)
		EndIf
		If hasDrowsiness
			StartTimerGameTime(0.5,DrowsinessTimer)
		EndIf
		HealingStarted = true
		If HealingStarted_First
			button = Winter_HealingStarted_First.Show()
			If button == 1
				HealingStarted_First = false
			EndIf
		EndIf
		Winter_HealingStarted.Show()
		WriteLine(Log, "Started Healing")
	EndIf
EndFunction

Function StartHealingSevere()
		Winter_Dispel_Dying_Spell.Cast(Player,Player)
		If hasAmnesia
			Player.RemovePerk(Winter_Dying_Amnesia)
			Winter_Dying_Amnesia_Recovered.Show()
			hasAmnesia = false
			WriteLine(Log, "Amnesia Healed")
		EndIf
		If hasParadoxicalUndressing
			Player.RemovePerk(Winter_Dying_ParadoxicalUndressing)
			Winter_Dying_ParadoxicalUndressing_Recovered.Show()
			hasParadoxicalUndressing = false
			WriteLine(Log, "Paradoxical Undressing Healed")
		EndIf
		If hasTerminalBurrowing
			Player.RemovePerk(Winter_Dying_TerminalBurrowing)
			Winter_Dying_TerminalBurrowing_Recovered.Show()
			hasTerminalBurrowing = false
			WriteLine(Log, "Terminal Burrowing Healed")
		EndIf

EndFunction

Function CancelHealTimers()
	HealingStarted = false
	CancelTimer(GangreneTimer)
	CancelTimer(FrostbiteTimer)
	CancelTimer(PneumoniaTimer)
	CancelTimer(ConfusionTimer)
	CancelTimer(DrowsinessTimer)
	Winter_HealingStopped.Show()
	WriteLine(Log, "Cancelled Healing")
EndFunction

Function ResetHelperMessages()
	;Reset Helper Messages
	 HealingStarted_First = true 
	 WarmBonus_First = true 
	 MildHypothermia_First = true 
	 Shivering_First = true 
	 IncreasedMetabolism_First = true 
	 Frostnip_First = true 
	 TrenchFoot_First = true 
	 Sweating_First = true 
	 ModerateHypothermia_First = true 
	 Pneumonia_First = true 
	 Gangrene_First = true 
	 Chilblains_First = true 
	 Frostbite_First = true 
	 Confusion_First = true 
	 Drowsiness_First = true 
	 SevereHypothermia_First = true 
	 ParadoxicalUndressing_First = true 
	 Amnesia_First = true 
	 TerminalBurrowing_First = true
EndFunction

Function HandleWarm(bool Add)
	If Add
		If hasWarm == false
			Winter_Warm_WarmBonus.Cast(Player,Player)
			Winter_Warm_WarmBonus_Gained.Show()
			hasWarm = true
			If(WarmBonus_First)
				button = Winter_Warm_WarmBonus_First.Show()
				If button == 1
					WarmBonus_First = false
				EndIf
			EndIf
		EndIf
	Else
		If hasWarm
			Player.DispelSpell(Winter_Warm_WarmBonus)
			hasWarm = false
		EndIf
	EndIf
EndFunction

Function HandleMildHypothermia(bool Add)
	If Add
		If hasMildHypothermia == false
			Player.EquipItem(Winter_Cold_MildHypothermia_Description, abSilent = true)
			Player.AddPerk(Winter_Cold_MildHypothermia)
			Winter_Cold_MildHypothermia_Gained.Show()
			hasMildHypothermia = true
			If(MildHypothermia_First)
				button = Winter_Cold_MildHypothermia_First.Show()
				If button == 1
					MildHypothermia_First = false
				EndIf
			EndIf
			WriteLine(Log, "Gained Mild Hypothermia")
		EndIf
	Else
		If hasMildHypothermia
			Winter_Dispel_Cold_Spell.Cast(Player,Player)
			Player.RemovePerk(Winter_Cold_MildHypothermia)
			Winter_Cold_MildHypothermia_Recovered.Show()
			hasMildHypothermia = false
			WriteLine(Log, "Healed Mild Hypothermia")
		EndIf
	EndIf
EndFunction

Function HandleModerateHypothermia(bool Add)
	If Add
		If hasModerateHypothermia == false
			Player.EquipItem(Winter_Freezing_ModerateHypothermia_Description, abSilent = true)
			Player.AddPerk(Winter_Freezing_ModerateHypothermia)
			Winter_Freezing_ModerateHypothermia_Gained.Show()
			hasModerateHypothermia = true
			If(ModerateHypothermia_First)
				button = Winter_Freezing_ModerateHypothermia_First.Show()
				If button == 1
					ModerateHypothermia_First = false
				EndIf
			EndIf
			WriteLine(Log, "Gained Moderate Hypothermia")
		EndIf
	Else
		If hasModerateHypothermia
			Winter_Dispel_Freezing_Spell.Cast(Player,Player)
			Player.RemovePerk(Winter_Freezing_ModerateHypothermia)
			Winter_Freezing_ModerateHypothermia_Recovered.Show()
			hasModerateHypothermia = false
			WriteLine(Log, "Healed Moderate Hypothermia")
		EndIf
	EndIf
EndFunction

Function HandleSevereHypothermia(bool Add)
	If Add
		If hasSevereHypothermia == false
			Player.EquipItem(Winter_Dying_SevereHypothermia_Description, abSilent = true)
			Player.AddPerk(Winter_Dying_SevereHypothermia)
			Winter_Dying_SevereHypothermia_Gained.Show()
			hasSevereHypothermia = true
			If(SevereHypothermia_First)
				button = Winter_Dying_SevereHypothermia_First.Show()
				If button == 1
					SevereHypothermia_First = false
				EndIf
			EndIf
			WriteLine(Log, "Gained Severe Hypothermia")
		EndIf
	Else
		If hasSevereHypothermia
			Winter_Dispel_Dying_Spell.Cast(Player,Player)
			Player.RemovePerk(Winter_Dying_SevereHypothermia)
			Winter_Dying_SevereHypothermia_Recovered.Show()
			hasSevereHypothermia = false
			WriteLine(Log, "Healed Severe Hypothermia")
		EndIf
	EndIf
EndFunction

Function SetFreezing(bool value)
	If value
		RegisterForCustomEvent(Thermodynamics, "OnChanged")
		Warm = 			0.0
		Comfortable = 	0.0
		Cold =			0.0
		Freezing = 		0.0
		Dying = 		0.0
	Else
		UnRegisterForCustomEvent(Thermodynamics, "OnChanged")
		;Remove any Constant effects
		Warm = 			0.0
		Comfortable = 	0.0
		Cold =			0.0
		Freezing = 		0.0
		Dying = 		0.0
		Winter_Dispel_All_Spell.Cast(Player,Player)
		Player.DispelSpell(Winter_Warm_WarmBonus)
		hasWarm = false
		Player.RemovePerk(Winter_Cold_MildHypothermia)
		hasMildHypothermia = false
		Player.RemovePerk(Winter_Freezing_ModerateHypothermia)
		hasModerateHypothermia = false
		Player.RemovePerk(Winter_Dying_SevereHypothermia)
		hasSevereHypothermia = false
		;Remove any Random effects
		Player.RemovePerk(Winter_Cold_Shivering)
		hasShivering = false
		Player.RemovePerk(Winter_Cold_IncreasedMetabolism)
		hasIncreasedMetabolism = false
		Player.RemovePerk(Winter_Cold_TrenchFoot)
		hasTrenchfoot = false
		Player.RemovePerk(Winter_Cold_Frostnip)
		hasFrostnip = false
		hasSweating = false
		Player.RemovePerk(Winter_Freezing_Pneumonia)
		hasPneumonia = false
		Player.RemovePerk(Winter_Freezing_Gangrene)
		hasGangrene = false
		Player.RemovePerk(Winter_Freezing_Frostbite)
		hasFrostbite = false
		Player.RemovePerk(Winter_Freezing_Chilblains)
		hasChilblains = false
		Player.RemovePerk(Winter_Freezing_Drowsiness)
		hasDrowsiness = false
		Player.RemovePerk(Winter_Freezing_Confusion)
		hasConfusion = false
		Player.RemovePerk(Winter_Dying_Amnesia)
		hasAmnesia = false
		Player.RemovePerk(Winter_Dying_ParadoxicalUndressing)
		hasParadoxicalUndressing = false
		Player.RemovePerk(Winter_Dying_TerminalBurrowing)
		hasTerminalBurrowing = false
		;Reset Helper Messages
		ResetHelperMessages()
		;Cancel any Timers
		CancelTimerGameTime(HeatThresholdTimer)
		CancelHealTimers()
	EndIf
EndFunction

Function ResetHelpers()
	 HealingStarted_First = true 
	;   Warm----------------------------------------
	 WarmBonus_First = true 
	;   Cold----------------------------------------
	  MildHypothermia_First = true 
	 Shivering_First = true 
	 IncreasedMetabolism_First = true 
	 Frostnip_First = true 
	 TrenchFoot_First = true 
	 Sweating_First = true 
	;   Freezing------------------------------------
	 ModerateHypothermia_First = true 
	 Pneumonia_First = true 
	 Gangrene_First = true 
	 Chilblains_First = true 
	 Frostbite_First = true 
	 Confusion_First = true 
	 Drowsiness_First = true 
	;   Dying---------------------------------------
	 SevereHypothermia_First = true 
	 ParadoxicalUndressing_First = true 
	 Amnesia_First = true 
	 TerminalBurrowing_First = true 
EndFunction

;======================================Properties==================================================

Group Context
	Gear:DetectInteriors Property DetectInteriors Auto Const Mandatory
	World:Thermodynamics Property Thermodynamics Auto Const Mandatory
EndGroup

Group HeatThreshold

GlobalVariable Property Winter_Warm Auto
GlobalVariable Property Winter_Comfortable Auto
GlobalVariable Property Winter_Cold Auto
GlobalVariable Property Winter_Freezing Auto
GlobalVariable Property Winter_Dying Auto

float Property Warm Hidden
	float Function Get()
		return Winter_Warm.GetValue()
	EndFunction
	Function Set(float value)
		Winter_Warm.SetValue(value)
	EndFunction
EndProperty

float Property Comfortable Hidden
	float Function Get()
		return Winter_Comfortable.GetValue()
	EndFunction
	Function Set(float value)
		Winter_Comfortable.SetValue(value)
	EndFunction
EndProperty

float Property Cold Hidden
	float Function Get()
		return Winter_Cold.GetValue()
	EndFunction
	Function Set(float value)
		Winter_Cold.SetValue(value)
	EndFunction
EndProperty

float Property Freezing Hidden
	float Function Get()
		return Winter_Freezing.GetValue()
	EndFunction
	Function Set(float value)
		Winter_Freezing.SetValue(value)
	EndFunction
EndProperty

float Property Dying Hidden
	float Function Get()
		return Winter_Dying.GetValue()
	EndFunction
	Function Set(float value)
		Winter_Dying.SetValue(value)
	EndFunction
EndProperty

EndGroup

Group Conditions
;   Warm----------------------------------------
	Spell Property Winter_Warm_WarmBonus Auto Const
	{Automatically added when the Player is in the Warm Threshold}
;	Comfortable---------------------------------	
	; No Negative or positive effects
;   Cold----------------------------------------
	Perk Property Winter_Cold_MildHypothermia Auto Const
	{Automatically added when the Player is in the Cold Threshold}
	Perk Property Winter_Cold_Shivering Auto Const
	Perk Property Winter_Cold_IncreasedMetabolism Auto Const
	Perk Property Winter_Cold_Frostnip Auto Const
	Perk Property Winter_Cold_TrenchFoot Auto Const
	;Sweating (handled immedietely)
;   Freezing------------------------------------
	Perk Property Winter_Freezing_ModerateHypothermia Auto Const
	{Automatically added when the Player is in the Freezing Threshold}
	Perk Property Winter_Freezing_Pneumonia Auto Const
	Perk Property Winter_Freezing_Gangrene Auto Const
	Perk Property Winter_Freezing_Chilblains Auto Const
	Perk Property Winter_Freezing_Frostbite Auto Const
	Perk Property Winter_Freezing_Confusion Auto Const
	Perk Property Winter_Freezing_Drowsiness Auto Const
;   Dying---------------------------------------
	Perk Property Winter_Dying_SevereHypothermia Auto Const
	{Automatically added when the Player is in the Dying Threshold}
	Perk Property Winter_Dying_ParadoxicalUndressing Auto Const
	Perk Property Winter_Dying_Amnesia Auto Const
	Perk Property Winter_Dying_TerminalBurrowing Auto Const
EndGroup

Group Descriptions
;   Cold----------------------------------------
	Potion Property Winter_Cold_IncreasedMetabolism_Description Auto Const
	Potion Property Winter_Cold_MildHypothermia_Description Auto Const
	Potion Property Winter_Cold_Shivering_Description Auto Const
	Potion Property Winter_Cold_TrenchFoot_Description Auto Const
;   Freezing------------------------------------
	Potion Property Winter_Freezing_ModerateHypothermia_Description Auto Const
	Potion Property Winter_Freezing_Pneumonia_Description Auto Const
	Potion Property Winter_Freezing_Gangrene_Description Auto Const
	Potion Property Winter_Freezing_Chilblains_Description Auto Const
	Potion Property Winter_Freezing_Frostbite_Description Auto Const
	Potion Property Winter_Freezing_Confusion_Description Auto Const
	Potion Property Winter_Freezing_Drowsiness_Description Auto Const
;   Dying---------------------------------------
	Potion Property Winter_Dying_SevereHypothermia_Description Auto Const
	Potion Property Winter_Dying_ParadoxicalUndressing_Description Auto Const
	Potion Property Winter_Dying_Amnesia_Description Auto Const
	Potion Property Winter_Dying_TerminalBurrowing_Description Auto Const
	
	Spell Property Winter_Dispel_All_Spell Auto Const
	Spell Property Winter_Dispel_Cold_Spell Auto Const
	Spell Property Winter_Dispel_Freezing_Spell Auto Const
	Spell Property Winter_Dispel_Dying_Spell Auto Const
	Spell Property Winter_Dispel_Pneumonia_Spell Auto Const
	Spell Property Winter_Dispel_Gangrene_Spell Auto Const
	Spell Property Winter_Dispel_Chilblains_Spell Auto Const
	Spell Property Winter_Dispel_Frostbite_Spell Auto Const
	Spell Property Winter_Dispel_Confusion_Spell Auto Const
	Spell Property Winter_Dispel_Drowsiness_Spell Auto Const
	
EndGroup

Group Messages

	;================================================================
	; Messages for the player to indicate that they have Gained an Ailment
	
	Message Property Winter_HealingStarted Auto Const
	Message Property Winter_HealingStopped Auto Const
	;   Warm----------------------------------------
	Message Property Winter_Warm_WarmBonus_Gained Auto Const
	{Automatically added when the Player is in the Warm Threshold}
;	Comfortable---------------------------------	
	; No Negative or positive effects
;   Cold----------------------------------------
	Message Property Winter_Cold_MildHypothermia_Gained Auto Const
	{Automatically added when the Player is in the Cold Threshold}
	Message Property Winter_Cold_Shivering_Gained Auto Const
	Message Property Winter_Cold_IncreasedMetabolism_Gained Auto Const
	Message Property Winter_Cold_Frostnip_Gained Auto Const
	Message Property Winter_Cold_TrenchFoot_Gained Auto Const
	Message Property Winter_Cold_Sweating_Gained Auto Const
;   Freezing------------------------------------
	Message Property Winter_Freezing_ModerateHypothermia_Gained Auto Const
	{Automatically added when the Player is in the Freezing Threshold}
	Message Property Winter_Freezing_Pneumonia_Gained Auto Const
	Message Property Winter_Freezing_Gangrene_Gained Auto Const
	Message Property Winter_Freezing_Chilblains_Gained Auto Const
	Message Property Winter_Freezing_Frostbite_Gained Auto Const
	Message Property Winter_Freezing_Confusion_Gained Auto Const
	Message Property Winter_Freezing_Drowsiness_Gained Auto Const
;   Dying---------------------------------------
	Message Property Winter_Dying_SevereHypothermia_Gained Auto Const
	{Automatically added when the Player is in the Dying Threshold}
	Message Property Winter_Dying_ParadoxicalUndressing_Gained Auto Const
	Message Property Winter_Dying_Amnesia_Gained Auto Const
	Message Property Winter_Dying_TerminalBurrowing_Gained Auto Const
	
	;===================================================================
	; Messages for the player that explain the Ailment's mechanics
	
	Message Property Winter_HealingStarted_First Auto Const
	;   Warm----------------------------------------
	Message Property Winter_Warm_WarmBonus_First Auto Const
	{Automatically added when the Player is in the Warm Threshold}
;	Comfortable---------------------------------	
	; No Negative or positive effects
;   Cold----------------------------------------
	Message Property Winter_Cold_MildHypothermia_First Auto Const
	{Automatically added when the Player is in the Cold Threshold}
	Message Property Winter_Cold_Shivering_First Auto Const
	Message Property Winter_Cold_IncreasedMetabolism_First Auto Const
	Message Property Winter_Cold_Frostnip_First Auto Const
	Message Property Winter_Cold_TrenchFoot_First Auto Const
	Message Property Winter_Cold_Sweating_First Auto Const
;   Freezing------------------------------------
	Message Property Winter_Freezing_ModerateHypothermia_First Auto Const
	{Automatically added when the Player is in the Freezing Threshold}
	Message Property Winter_Freezing_Pneumonia_First Auto Const
	Message Property Winter_Freezing_Gangrene_First Auto Const
	Message Property Winter_Freezing_Chilblains_First Auto Const
	Message Property Winter_Freezing_Frostbite_First Auto Const
	Message Property Winter_Freezing_Confusion_First Auto Const
	Message Property Winter_Freezing_Drowsiness_First Auto Const
;   Dying---------------------------------------
	Message Property Winter_Dying_SevereHypothermia_First Auto Const
	{Automatically added when the Player is in the Dying Threshold}
	Message Property Winter_Dying_ParadoxicalUndressing_First Auto Const
	Message Property Winter_Dying_Amnesia_First Auto Const
	Message Property Winter_Dying_TerminalBurrowing_First Auto Const
	
	;===================================================================
	; Messages that express recovery from an ailment
	
;   Cold----------------------------------------
	Message Property Winter_Cold_MildHypothermia_Recovered Auto Const
	{Automatically added when the Player is in the Cold Threshold}
	Message Property Winter_Cold_Shivering_Recovered Auto Const
	Message Property Winter_Cold_IncreasedMetabolism_Recovered Auto Const
	Message Property Winter_Cold_Frostnip_Recovered Auto Const
	Message Property Winter_Cold_TrenchFoot_Recovered Auto Const
;   Freezing------------------------------------
	Message Property Winter_Freezing_ModerateHypothermia_Recovered Auto Const
	{Automatically added when the Player is in the Freezing Threshold}
	Message Property Winter_Freezing_Pneumonia_Recovered Auto Const
	Message Property Winter_Freezing_Gangrene_Recovered Auto Const
	Message Property Winter_Freezing_Chilblains_Recovered Auto Const
	Message Property Winter_Freezing_Frostbite_Recovered Auto Const
	Message Property Winter_Freezing_Confusion_Recovered Auto Const
	Message Property Winter_Freezing_Drowsiness_Recovered Auto Const
;   Dying---------------------------------------
	Message Property Winter_Dying_SevereHypothermia_Recovered Auto Const
	{Automatically added when the Player is in the Dying Threshold}
	Message Property Winter_Dying_ParadoxicalUndressing_Recovered Auto Const
	Message Property Winter_Dying_Amnesia_Recovered Auto Const
	Message Property Winter_Dying_TerminalBurrowing_Recovered Auto Const
EndGroup
