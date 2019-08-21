ScriptName NuclearWinter:Terminals:DifficultyTerminal extends Terminal
{Terminal:Winter_Difficulty_Terminal}

import NuclearWinter
import NuclearWinter:Context
import Shared:Log

Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
  If auiMenuItemID == 1 ; Difficulty Scalar +0.1
	Winter_Difficulty.SetValue(Winter_Difficulty.GetValue() + 0.1)
  ElseIf auiMenuItemID == 2 ; Set Nuclear Winter
	Winter_Preset.SetValue(0.0)
  ElseIf auiMenuItemID == 3 ; Set Realistic Winter
	Winter_Preset.SetValue(1.0)
  ElseIf auiMenuItemID == 4 ; Difficulty Scalar -0.1
	Winter_Difficulty.SetValue(Winter_Difficulty.GetValue() - 0.1)
  ElseIf auiMenuItemID == 5 ; Increase Max Insulation +1.0
	Equipment.MaxInsulation = Equipment.MaxInsulation + 1
	Equipment.UpdateExposure()
  ElseIf auiMenuItemID == 6 ; Decrease Max Insulation -1.0
	Equipment.MaxInsulation = Equipment.MaxInsulation - 1
	Equipment.UpdateExposure()
  ElseIf auiMenuItemID == 7 ; Return
	
  EndIf
endEvent


Group Properties
	Gear:Equipment Property Equipment Auto
	GlobalVariable Property Winter_Preset Auto
	GlobalVariable Property Winter_Difficulty Auto
EndGroup
