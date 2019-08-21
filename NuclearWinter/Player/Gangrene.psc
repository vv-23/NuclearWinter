Scriptname NuclearWinter:Player:Gangrene extends ActiveMagicEffect 

import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log
Actor Player 
int WorsenTimer = 0
int SpreadTimer = 1
int DamageTimer = 2

bool inLeftLeg = false
bool inLeftArm = false
bool inRightArm = false
bool inRightLeg = false

int DiseaseStageLeftArm = 0
int DiseaseStageRightArm = 0
int DiseaseStageLeftLeg = 0
int DiseaseStageRightLeg = 0

Event OnInIt()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Freezing"
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Player = Game.GetPlayer()
	ChooseLimb(Utility.RandomInt(0, 3))
	If(Player.HasMagicEffect(HC_Herbal_Antimicrobial_Effect))
		StartTimerGameTime(5, WorsenTimer)
		StartTimerGameTime(5, DamageTimer)
		StartTimerGameTime(Utility.RandomInt(3, 7),SpreadTimer)
	Else
		StartTimerGameTime(2, WorsenTimer)
		StartTimerGameTime(2, DamageTimer)
		StartTimerGameTime(Utility.RandomInt(1, 3),SpreadTimer)
	EndIf
	WriteLine(Log, "Applying Gangrene.")
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	CancelTimerGameTime(WorsenTimer)
	CancelTimerGameTime(DamageTimer)
	CancelTimerGameTime(SpreadTimer)
	WriteLine(Log, "Removing Gangrene.")
EndEvent

Event OnTimerGameTime(int aiTimerID)
	;Increase the damage of the disease on the limb
	If Freezing.Warm != 1.0 && Freezing.Comfortable != 1.0
		If aiTimerID == WorsenTimer
			If(inLeftLeg)
				DiseaseStageLeftLeg = DiseaseStageLeftLeg + 1
				Winter_Freezing_Gangrene_LeftLegWorsen.Show(DiseaseStageLeftLeg)
			EndIf
			If(inRightLeg)
				DiseaseStageRightLeg = DiseaseStageRightLeg + 1
				Winter_Freezing_Gangrene_RightLegWorsen.Show(DiseaseStageRightLeg)
			EndIf
			If(inLeftArm)
				DiseaseStageLeftArm = DiseaseStageLeftArm + 1
				Winter_Freezing_Gangrene_LeftArmWorsen.Show(DiseaseStageLeftArm)
			EndIf
			If(inRightArm)
				DiseaseStageRightArm = DiseaseStageRightArm + 1
				Winter_Freezing_Gangrene_RightArmWorsen.Show(DiseaseStageRightArm)
			EndIf
			If(Player.HasMagicEffect(HC_Herbal_Antimicrobial_Effect))
				StartTimerGameTime(5, WorsenTimer)
			Else
				StartTimerGameTime(2, WorsenTimer)
			EndIf
			WriteLine(Log, "Worsens Gangrene.")
		EndIf
		;Spread the disease to other limbs
		If aiTimerID == SpreadTimer
			ChooseLimb(Utility.RandomInt(0, 3))
			If(Player.HasMagicEffect(HC_Herbal_Antimicrobial_Effect))
				StartTimerGameTime(Utility.RandomInt(3, 7),SpreadTimer)
			Else
				StartTimerGameTime(Utility.RandomInt(1, 3),SpreadTimer)
			EndIf
			WriteLine(Log, "Spreads Gangrene.")
		EndIf
	Else
		If(Player.HasMagicEffect(HC_Herbal_Antimicrobial_Effect))
			StartTimerGameTime(5, WorsenTimer)
		Else
			StartTimerGameTime(2, WorsenTimer)
		EndIf
		If(Player.HasMagicEffect(HC_Herbal_Antimicrobial_Effect))
			StartTimerGameTime(Utility.RandomInt(3, 7),SpreadTimer)
		Else
			StartTimerGameTime(Utility.RandomInt(1, 3),SpreadTimer)
		EndIf
		WriteLine(Log, "Do Nothing Gangrene.")
	EndIf
	;Damage the limbs on an interval
	If aiTimerID == DamageTimer
		int a = DiseaseStageLeftLeg
		int b = DiseaseStageRightLeg
		int c = DiseaseStageLeftArm
		int d = DiseaseStageRightArm
		While(a != 0 && b != 0 && c != 0 && d != 0)
			Utility.wait(0.1)
			If(inLeftLeg && a != 0)
				Winter_Freezing_Gangrene_LeftLeg.Cast(Player,Player)
				a = a - 1
			EndIf
			Utility.wait(0.1)
			If(inRightLeg && b != 0)
				Winter_Freezing_Gangrene_RightLeg.Cast(Player,Player)
				b = b - 1
			EndIf
			Utility.wait(0.1)
			If(inLeftArm && c != 0)
				Winter_Freezing_Gangrene_LeftArm.Cast(Player,Player)
				c = c - 1
			EndIf
			Utility.wait(0.1)
			If(inRightArm && d != 0)
				Winter_Freezing_Gangrene_RightArm.Cast(Player,Player)
				d = d - 1
			EndIf
		EndWhile
		If(Player.HasMagicEffect(HC_Herbal_Antimicrobial_Effect))
			StartTimerGameTime(5, DamageTimer)
		Else
			StartTimerGameTime(2, DamageTimer)
		EndIf
	EndIf
	
	
EndEvent

Function ChooseLimb(int limb)
	If limb == 0
		If(!inLeftLeg)
			DiseaseStageLeftLeg = 1
			Winter_Freezing_Gangrene_LeftLeg.Cast(Player, Player)
			inLeftLeg = true
			Winter_Freezing_Gangrene_LeftLegSpread.Show()
		Else
			; If the limb is already infected, worsen the limb
			StartTimerGameTime(0.2, WorsenTimer)
		EndIf
	ElseIf limb == 1
		If(!inRightLeg)
			DiseaseStageRightLeg = 1
			Winter_Freezing_Gangrene_RightLeg.Cast(Player, Player)
			inRightLeg = true
			Winter_Freezing_Gangrene_RightLegSpread.Show()
		Else
			; If the limb is already infected, worsen the limb
			StartTimerGameTime(0.2, WorsenTimer)
		EndIf
	ElseIf limb == 2
		If(!inLeftArm)
			DiseaseStageLeftArm = 1
			Winter_Freezing_Gangrene_LeftArm.Cast(Player, Player)
			inLeftArm = true
			Winter_Freezing_Gangrene_LeftArmSpread.Show()
		Else
			; If the limb is already infected, worsen the limb
			StartTimerGameTime(0.2, WorsenTimer)
		EndIf
	Else
		If(!inRightArm)
			DiseaseStageRightArm = 1
			Winter_Freezing_Gangrene_RightArm.Cast(Player, Player)
			inRightArm = true
			Winter_Freezing_Gangrene_RightArmSpread.Show()
		Else
			; If the limb is already infected, worsen the limb
			StartTimerGameTime(0.2, WorsenTimer)
		EndIf
	EndIf
EndFunction

Group Properties
	Player:Freezing Property Freezing Auto Const Mandatory
	Spell Property Winter_Freezing_Gangrene_LeftLeg Auto Const
	Spell Property Winter_Freezing_Gangrene_RightLeg Auto Const
	Spell Property Winter_Freezing_Gangrene_LeftArm Auto Const
	Spell Property Winter_Freezing_Gangrene_RightArm Auto Const
	
	Message Property Winter_Freezing_Gangrene_LeftLegSpread Auto
	Message Property Winter_Freezing_Gangrene_RightLegSpread Auto
	Message Property Winter_Freezing_Gangrene_LeftArmSpread Auto
	Message Property Winter_Freezing_Gangrene_RightArmSpread Auto
	
	Message Property Winter_Freezing_Gangrene_LeftLegWorsen Auto
	Message Property Winter_Freezing_Gangrene_RightLegWorsen Auto
	Message Property Winter_Freezing_Gangrene_LeftArmWorsen Auto
	Message Property Winter_Freezing_Gangrene_RightArmWorsen Auto
	
	MagicEffect Property HC_Herbal_Antimicrobial_Effect Auto
EndGroup
