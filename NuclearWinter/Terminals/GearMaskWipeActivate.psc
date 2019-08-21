ScriptName NuclearWinter:Terminals:GearMaskWipeActivate extends Terminal
import Shared:Log

UserLog Log

int MaskWipeActivateOption = 1 const
int BloodToggle = 2 const
int DirtToggle = 3 const
int RainToggle = 4 const
int SnowToggle = 5 const
int DustToggle = 6 const
CustomEvent OnChanged

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
    If (auiMenuItemID == MaskWipeActivateOption)
		If MaskWipe.MaskWipeActivate
			MaskWipe.MaskWipeActivate = false
			WriteLine(Log, "MaskWipeActivate Disabled")
		ElseIf MaskWipe.MaskWipeActivate == false
			MaskWipe.MaskWipeActivate = true
			WriteLine(Log, "MaskWipeActivate Activated")
		EndIf
		Debug.Notification("MaskWipeActivate Toggled | " + MaskWipe.MaskWipeActivate)
		SendCustomEvent("OnChanged")
	ElseIf (auiMenuItemID == BloodToggle)
		If MaskWipe.BloodToggle == true
			MaskWipe.BloodToggle = false
			MaskWipe.EndBlood(true)
			MaskWipe.SmearBlood(true)
		ElseIf MaskWipe.BloodToggle == false
			MaskWipe.BloodToggle = true
			Maskwipe.Evaluate()
		EndIf
		Debug.Notification("Blood Toggled | " + MaskWipe.BloodToggle)
	ElseIf (auiMenuItemID == DirtToggle)
		If MaskWipe.DirtToggle == true
			MaskWipe.DirtToggle = false
			MaskWipe.EndMud(true)
		ElseIf MaskWipe.DirtToggle == false
			MaskWipe.DirtToggle = true
			Maskwipe.Evaluate()
		EndIf
		Debug.Notification("Dirt Toggled | " + MaskWipe.DirtToggle)
	ElseIf (auiMenuItemID == RainToggle)
		If MaskWipe.RainToggle == true
			MaskWipe.RainToggle = false
			MaskWipe.EndRain(false, false)
		ElseIf MaskWipe.RainToggle == false
			MaskWipe.RainToggle = true
			Maskwipe.Evaluate()
		EndIf
		Debug.Notification("Rain Toggled | " + MaskWipe.RainToggle)
	ElseIf (auiMenuItemID == SnowToggle)
		If MaskWipe.SnowToggle == true
			MaskWipe.SnowToggle = false
			MaskWipe.EndSnow(false)
		ElseIf MaskWipe.SnowToggle == false
			MaskWipe.SnowToggle = true
			Maskwipe.Evaluate()
		EndIf
		Debug.Notification("Snow Toggled | " + MaskWipe.RainToggle)
	ElseIf (auiMenuItemID == SnowToggle)
		If MaskWipe.DustToggle == true
			MaskWipe.DustToggle = false
			MaskWipe.EndDust(false)
		ElseIf Maskwipe.DustToggle == false
			MaskWipe.DustToggle = true
			Maskwipe.Evaluate()
		EndIf
		Debug.Notification("Dust Toggled | " + MaskWipe.DustToggle)
    EndIf
	
EndEvent


; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Context Property Context Auto Const Mandatory
	NuclearWinter:Gear:MaskWipe Property MaskWipe Auto Const Mandatory
EndGroup
