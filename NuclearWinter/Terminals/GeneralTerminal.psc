ScriptName NuclearWinter:Terminals:GeneralTerminal extends Terminal
{Terminal:Winter_General_Terminal}

import NuclearWinter
import NuclearWinter:Context
import Shared:Log

Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
  If auiMenuItemID == 1 ;Activate Nuclear Winter
	ContextActivation.SetActivation()
  ElseIf auiMenuItemID == 2 ;Deactivate Nuclear Winter
	ContextActivation.SetActivation()
  ElseIf auiMenuItemID == 3 ;Reset Helper Messages
	ResetHelperMessages.Reset()
  ElseIf auiMenuItemID == 4 ; Gameplay System ON -> OFF
	ToggleGameplaySystem.SetGameplaySystem(false)
  ElseIf auiMenuItemID == 5 ; Gameplay System OFF -> ON
	ToggleGameplaySystem.SetGameplaySystem(true)
  ElseIf auiMenuItemID == 6 ; F&B ON -> OFF
	ToggleFoodSystem.SetFoodActivation()
  ElseIf auiMenuItemID == 7 ; F&B OFF -> ON
	ToggleFoodSystem.SetFoodActivation()
  ElseIf auiMenuItemID == 8 ; Temp F -> C
	Winter_TemperatureScale.SetValue(1.0)
  ElseIf auiMenuItemID == 9 ; Temp C -> F
	Winter_TemperatureScale.SetValue(0.0)
  ElseIf auiMenuItemID == 10 ; Wind MPH -> KPH
	Winter_WindScale.SetValue(1.0)
  ElseIf auiMenuItemID == 11 ; Wind KPH -> MPH
	Winter_WindScale.SetValue(0.0)
  ElseIf auiMenuItemID == 12 ; Shaders ON -> OFF
	WeatherShader.Toggle()
  ElseIf auiMenuItemID == 13 ; Shaders OFF -> ON
	WeatherShader.Toggle()
  ElseIf auiMenuItemID == 14 ; Return
  
  EndIf
endEvent


Group Properties
	NuclearWinter:ContextActivation Property ContextActivation Auto
	Terminals:ToggleFoodSystem Property ToggleFoodSystem Auto
	Terminals:ToggleGameplaySystem Property ToggleGameplaySystem Auto
	World:WeatherShader Property WeatherShader Auto
	Gear:ResetHelperMessages Property ResetHelperMessages Auto
	GlobalVariable Property Winter_TemperatureScale Auto
	GlobalVariable Property Winter_WindScale Auto
EndGroup
