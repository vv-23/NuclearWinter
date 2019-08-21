ScriptName NuclearWinter:Terminals:NPCCompanionMode extends Terminal
import NuclearWinter

; Events
;---------------------------------------------

Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
	If (auiMenuItemID == 2)
		Equip = false
	ElseIf(auiMenuItemID == 3)
		Equip = true
	EndIf
EndEvent


; Properties
;---------------------------------------------

Group Properties
	bool property Equip Auto
EndGroup
