Scriptname NuclearWinter:GUI:InsulationWidget extends NuclearWinter:GUI:HUDWidget
{QUST:Winter_Context}
import NuclearWinter
import NuclearWinter:Context
import Shared:Log
import Math

UserLog Log
Actor Player

int Command_UpdateInsulation1 = 100 const
int Command_UpdateInsulation2 = 150 const
int Command_UpdateShow = 200 const
int Command_UpdateNames1 = 300 const
int Command_UpdateNames2 = 400 const
int Command_UpdateNames3 = 500 const
int Command_UpdateNames4 = 600 const
int Command_UpdateNames5 = 700 const
int Command_UpdateNames6 = 800 const
int Command_UpdateNames7 = 900 const


; Events
;---------------------------------------------

Event OnInitialize()
	Log = GetLog(self)
	Log.FileName = "Winter_InsulationWidget"
	Player = Game.GetPlayer()
	isShowing = false
EndEvent


Event OnEnable()
	SetHUDToggle(true)
	ShowWidget()
	Utility.Wait(1.0)
	ShowWidget()
	RegisterForRemoteEvent(Player,"OnPlayerLoadGame")
EndEvent


Event OnDisable()
	SetHUDToggle(false)
	UnRegisterForRemoteEvent(Player,"OnPlayerLoadGame")
EndEvent

Event Actor.OnPlayerLoadGame(Actor akActor)
	Utility.Wait(1.0)
	TryLoad()
	ShowWidget()
	Utility.Wait(1.0)
	ShowWidget()
EndEvent

Event OnWidgetLoaded()
	UpdateInsulation()
EndEvent


; Functions
;---------------------------------------------

Function SetWidgetParameters()
	Utility.wait(0.2)
	SetOpacityModify(OpacityVal)
	SetScaleModify(ScaleX, ScaleY)
	SetPositionModify(X, Y)
EndFunction

;Opcaity ---------------------
Function SetOpacity(float value)
	Utility.wait(0.2)
	OpacityVal = value
	SetOpacityModify(OpacityVal)
EndFunction

;Scale ------------------------
Function SetXScale(float value)
	Utility.wait(0.2)
	ScaleX = value
	SetScaleModify(ScaleX, ScaleY)
EndFunction

Function SetYScale(float value)
	Utility.wait(0.2)
	ScaleY = value
	SetScaleModify(ScaleX, ScaleY)
EndFunction
;Position ----------------------
Function SetXPos(int value)
	Utility.wait(0.2)
	X = value
	SetPositionModify(X, Y)
EndFunction

Function SetYPos(int value)
	Utility.wait(0.2)
	Y = value
	SetPositionModify(X, Y)
EndFunction

Function SetHUDToggle(bool value)
	Utility.wait(0.2)
	HUDToggle = value
	If HUDToggle
		If(TryLoad())
			WriteLine(Log, "Loaded widget.")
		EndIf
	ElseIf HUDToggle == false
		If(Unload())
			WriteLine(Log, "Unloaded widget.")
		EndIf
	EndIf
	Debug.Notification("Insulation Widget | HUD Toggle: " + HUDToggle)
EndFunction

WidgetData Function Create()
	WidgetData widget = new WidgetData
	widget.ID = "InsulationWidget.swf"
	widget.X = X
	widget.Y = Y
	return widget
EndFunction


; Functions
;---------------------------------------------

bool Function TryLoad()
	If(HUDToggle)
		If (Load())
			UpdateInsulation()
			return true
		Else
			WriteLine(Log, "Could not try to load the widget.")
			return false
		EndIf
	Else
		WriteLine(Log, "Could not load the widget, it is toggled off.")
		return false
	EndIf
EndFunction

Function ShowWidget()
	float[] afArguments = new float[3]
	If isShowing
		isShowing = false
		afArguments[0] = 0.0
		SendNumber(Command_UpdateShow, afArguments)
		WriteLine(Log, "Showing widget.")
	Else	
		isShowing = true
		afArguments[0] = 1.0
		SendNumber(Command_UpdateShow, afArguments)
		WriteLine(Log, "Hiding widget.")
	EndIf
EndFunction


Function UpdateInsulation()
	; THESE ARGUMENTS NEED TO BE THE CULMINATION OF THE SLOTS THEY REPRESENT (ex. HEAD = EYES, HAIR TOP, NECK, HEAD BAND, BEARD, MOUTH, SCALP)
	If(Equipment.UniversalExposure == false)
		float[] afArguments = new float[5]
		afArguments[0] = (ExposureValues.CurrentlyEquippedValues[0] + ExposureValues.CurrentlyEquippedValues[1] + ExposureValues.CurrentlyEquippedValues[16] + ExposureValues.CurrentlyEquippedValues[17] + ExposureValues.CurrentlyEquippedValues[18] + ExposureValues.CurrentlyEquippedValues[19] + ExposureValues.CurrentlyEquippedValues[20] + ExposureValues.CurrentlyEquippedValues[22]) as Float
		afArguments[1] = (ExposureValues.CurrentlyEquippedValues[7] + ExposureValues.CurrentlyEquippedValues[12]) as Float
		afArguments[2] = (ExposureValues.CurrentlyEquippedValues[9] + ExposureValues.CurrentlyEquippedValues[14]) as Float
		afArguments[3] = (ExposureValues.CurrentlyEquippedValues[8] + ExposureValues.CurrentlyEquippedValues[13]) as Float
		afArguments[4] = (ExposureValues.CurrentlyEquippedValues[10] + ExposureValues.CurrentlyEquippedValues[15]) as Float
		WriteLine(Log, "arg0 " + afArguments[0] + " | " + "arg1 " + afArguments[1] + " | " + "arg2 " + afArguments[2] + " | " + "arg3 " + afArguments[3] + " | " + "arg4 " + afArguments[4])
		SendFiveNumbers(Command_UpdateInsulation1, afArguments)
		afArguments[0] = (ExposureValues.CurrentlyEquippedValues[6] + ExposureValues.CurrentlyEquippedValues[11]) as Float
		afArguments[1] = (ExposureValues.CurrentlyEquippedValues[3]) as Float
		afArguments[2] = (ExposureValues.CurrentlyEquippedValues[21] + ExposureValues.CurrentlyEquippedValues[24] + ExposureValues.CurrentlyEquippedValues[25] + ExposureValues.CurrentlyEquippedValues[26] + ExposureValues.CurrentlyEquippedValues[27] + ExposureValues.CurrentlyEquippedValues[28] + ExposureValues.CurrentlyEquippedValues[4] + ExposureValues.CurrentlyEquippedValues[5] + ExposureValues.CurrentlyEquippedValues[29] + Math.Ceiling(Player.GetValue(FrostResist))) as Float
		afArguments[3] = (Equipment.Exposure) as Float
		afArguments[4] = (Equipment.Exposure + 1) as Float
		WriteLine(Log, "arg0 " + afArguments[0] + " | " + "arg1 " + afArguments[1] + " | " + "arg2 " + afArguments[2] + " | " + "arg3 " + afArguments[3] + " | " + "arg4 " + afArguments[4])
		SendFiveNumbers(Command_UpdateInsulation2, afArguments)
		; THESE ARE THE STRING VALUES OF THE ARMORS
		String Head
		String LeftArm
		String LeftLeg
		String RightArm
		String RightLeg
		String Chest
		String Body
		If ExposureValues.CurrentlyEquippedArmor[0] != None
			If ExposureValues.CurrentlyEquippedArmor[0].GetName() != ""
				Head = ExposureValues.CurrentlyEquippedArmor[0].GetName() + "(" + ExposureValues.CurrentlyEquippedValues[0] + ")"
			EndIf
		EndIf
		If ExposureValues.CurrentlyEquippedArmor[16] != None
			If ExposureValues.CurrentlyEquippedArmor[16].GetName() != ""
				Head += "  " + ExposureValues.CurrentlyEquippedArmor[16].GetName() + "(" + ExposureValues.CurrentlyEquippedValues[16] + ")"
			EndIf
		EndIf
		If ExposureValues.CurrentlyEquippedArmor[17] != None
			If ExposureValues.CurrentlyEquippedArmor[17].GetName() != ""
				Head += "  " + ExposureValues.CurrentlyEquippedArmor[17].GetName() + "(" + ExposureValues.CurrentlyEquippedValues[17] + ")"
			EndIf
		EndIf
		If ExposureValues.CurrentlyEquippedArmor[18] != None
			If ExposureValues.CurrentlyEquippedArmor[18].GetName() != ""
				Head += "  " + ExposureValues.CurrentlyEquippedArmor[18].GetName() + "(" + ExposureValues.CurrentlyEquippedValues[18] + ")"
			EndIf
		EndIf
		If ExposureValues.CurrentlyEquippedArmor[19] != None
			If ExposureValues.CurrentlyEquippedArmor[19].GetName() != ""
				Head += "  " + ExposureValues.CurrentlyEquippedArmor[19].GetName() + "(" + ExposureValues.CurrentlyEquippedValues[19] + ")"
			EndIf
		EndIf
		If ExposureValues.CurrentlyEquippedArmor[20] != None
			If ExposureValues.CurrentlyEquippedArmor[20].GetName() != ""
				Head += "  " + ExposureValues.CurrentlyEquippedArmor[20].GetName() + "(" + ExposureValues.CurrentlyEquippedValues[20] + ")"
			EndIf
		EndIf
		;---------------------------------------------------
		If ExposureValues.CurrentlyEquippedArmor[7] != None
			If ExposureValues.CurrentlyEquippedArmor[7].GetName() != ""
				LeftArm = ExposureValues.CurrentlyEquippedArmor[7].GetName() + "(" + ExposureValues.CurrentlyEquippedValues[7] + ")"
			EndIf
		EndIf
		If ExposureValues.CurrentlyEquippedArmor[12] != None
			If ExposureValues.CurrentlyEquippedArmor[12].GetName() != ""
				LeftArm += "  " + ExposureValues.CurrentlyEquippedArmor[12].GetName() + "(" + ExposureValues.CurrentlyEquippedValues[12] + ")"
			EndIf
		EndIf
		;---------------------------------------------------
		If ExposureValues.CurrentlyEquippedArmor[9] != None
			If ExposureValues.CurrentlyEquippedArmor[9].GetName() != ""
				LeftLeg = ExposureValues.CurrentlyEquippedArmor[9].GetName() + "(" + ExposureValues.CurrentlyEquippedValues[9] + ")"
			EndIf
		EndIf
		If ExposureValues.CurrentlyEquippedArmor[14] != None
			If ExposureValues.CurrentlyEquippedArmor[14].GetName() != ""
				LeftLeg += "  " + ExposureValues.CurrentlyEquippedArmor[14].GetName() + "(" + ExposureValues.CurrentlyEquippedValues[14] + ")"
			EndIf
		EndIf
		;---------------------------------------------------
		If ExposureValues.CurrentlyEquippedArmor[8] != None
			If ExposureValues.CurrentlyEquippedArmor[8].GetName() != ""
				RightArm = ExposureValues.CurrentlyEquippedArmor[8].GetName() + "(" + ExposureValues.CurrentlyEquippedValues[8] + ")"
			EndIf
		EndIf
		If ExposureValues.CurrentlyEquippedArmor[13] != None
			If ExposureValues.CurrentlyEquippedArmor[13].GetName() != ""
				RightArm += "  " + ExposureValues.CurrentlyEquippedArmor[13].GetName() + "(" + ExposureValues.CurrentlyEquippedValues[13] + ")"
			EndIf
		EndIf
		;---------------------------------------------------
		If ExposureValues.CurrentlyEquippedArmor[10] != None
			If ExposureValues.CurrentlyEquippedArmor[10].GetName() != ""
				RightLeg = ExposureValues.CurrentlyEquippedArmor[10].GetName() + "(" + ExposureValues.CurrentlyEquippedValues[10] + ")"
			EndIf
		EndIf
		If ExposureValues.CurrentlyEquippedArmor[15] != None
			If ExposureValues.CurrentlyEquippedArmor[15].GetName() != ""
				RightLeg += "  " + ExposureValues.CurrentlyEquippedArmor[15].GetName() + "(" + ExposureValues.CurrentlyEquippedValues[15] + ")"
			EndIf
		EndIf
		;---------------------------------------------------
		If ExposureValues.CurrentlyEquippedArmor[6] != None
			If ExposureValues.CurrentlyEquippedArmor[6].GetName() != ""
				Chest = ExposureValues.CurrentlyEquippedArmor[6].GetName() + "(" + ExposureValues.CurrentlyEquippedValues[6] + ")"
			EndIf
		EndIf
		If ExposureValues.CurrentlyEquippedArmor[11] != None
			If ExposureValues.CurrentlyEquippedArmor[11].GetName() != ""
				Chest += "  " + ExposureValues.CurrentlyEquippedArmor[11].GetName() + "(" + ExposureValues.CurrentlyEquippedValues[11] + ")"
			EndIf
		EndIf
		;---------------------------------------------------
		If ExposureValues.CurrentlyEquippedArmor[3] != None
			If ExposureValues.CurrentlyEquippedArmor[3].GetName() != ""
				Body = ExposureValues.CurrentlyEquippedArmor[3].GetName() + "(" + ExposureValues.CurrentlyEquippedValues[3] + ")"
			EndIf
		EndIf
		If Head != ""
			SendText(Command_UpdateNames1, Head)
		Else
			SendText(Command_UpdateNames1, "None")
		EndIf
		If LeftArm != ""
			SendText(Command_UpdateNames2, LeftArm)
		Else
			SendText(Command_UpdateNames2, "None")
		EndIf
		If LeftLeg != ""
			SendText(Command_UpdateNames3, LeftLeg)
		Else
			SendText(Command_UpdateNames3, "None")
		EndIf
		If RightArm != ""
			SendText(Command_UpdateNames4, RightArm)
		Else
			SendText(Command_UpdateNames4, "None")
		EndIf
		If RightLeg != ""
			SendText(Command_UpdateNames5, RightLeg)
		Else
			SendText(Command_UpdateNames5, "None")
		EndIf
		If Chest != ""
			SendText(Command_UpdateNames6, Chest)
		Else
			SendText(Command_UpdateNames6, "None")
		EndIf
		If Body != ""
			SendText(Command_UpdateNames7, Body)
		Else
			SendText(Command_UpdateNames7, "None")
		EndIf
		WriteLine(Log, "Updating widget.")
		WriteLine(Log, "Body" + Body + " | " + "Head" + Head + " | " + "LeftArm" + LeftArm + " | " + "LeftLeg" + LeftLeg + " | " + "RightArm" + RightArm + " | " + "RightLeg" + RightLeg + " | " + "Chest" + Chest)
	Else
		float[] afArguments = new float[5]
		afArguments[0] = (0) as Float
		afArguments[1] = (0) as Float
		afArguments[2] = (0) as Float
		afArguments[3] = (0) as Float
		afArguments[4] = (0) as Float
		SendFiveNumbers(Command_UpdateInsulation1, afArguments)
		afArguments[0] = (0) as Float
		afArguments[1] = (0) as Float
		afArguments[2] = (0) as Float
		afArguments[3] = (Equipment.Exposure) as Float
		afArguments[4] = (Equipment.Exposure + 1) as Float
		SendFiveNumbers(Command_UpdateInsulation2, afArguments)
	EndIf
EndFunction

Function InsulationToggle()
	ShowWidget()
EndFunction

; Properties
;---------------------------------------------

Group Context
	Gear:ExposureValues Property ExposureValues Auto Const Mandatory
	Gear:Equipment Property Equipment Auto Const Mandatory
EndGroup

Group Properties
	float property OpacityVal = 1.0 Auto 
	float property ScaleX = 1.0 Auto
	float property ScaleY = 1.0 Auto
	int property X = 10 Auto
	int property Y = 10 Auto
	bool property HUDToggle Auto 
	bool property isShowing Auto
	ActorValue Property FrostResist Auto
EndGroup
