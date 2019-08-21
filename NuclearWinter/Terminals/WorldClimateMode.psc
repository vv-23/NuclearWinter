ScriptName NuclearWinter:Terminals:WorldClimateMode extends Terminal
import NuclearWinter

; Events
;---------------------------------------------

Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
	If (auiMenuItemID == 3)
		Climate.Mode = Climate.ModeHeavy
	ElseIf(auiMenuItemID == 2)
		Climate.Mode = Climate.ModeLite
	ElseIf(auiMenuItemID == 4)
		Climate.Mode = Climate.ModeNone
	EndIf
EndEvent


; Properties
;---------------------------------------------

Group Properties
	World:Climate Property Climate Auto Const Mandatory
EndGroup
