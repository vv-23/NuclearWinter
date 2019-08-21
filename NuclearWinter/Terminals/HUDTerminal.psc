ScriptName NuclearWinter:Terminals:HUDTerminal extends Terminal
{Terminal:Winter_HUD_Terminal}

import NuclearWinter
import NuclearWinter:Context
import Shared:Log

Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
  If auiMenuItemID == 1 
  
  ElseIf auiMenuItemID == 2 ; Temp Widget ON -> OFF
	TemperatureWidget.SetHudToggle(false)
  ElseIf auiMenuItemID == 3 ; Temp Widget OFF -> ON
	TemperatureWidget.SetHudToggle(true)
  ElseIf auiMenuItemID == 4 ; Pos X + 10
	TemperatureWidget.SetXPos(TemperatureWidget.X + 10)
  ElseIf auiMenuItemID == 5 ; Pos Y + 10
	TemperatureWidget.SetYPos(TemperatureWidget.Y + 10)
  ElseIf auiMenuItemID == 6 ; Pos X - 10
	TemperatureWidget.SetXPos(TemperatureWidget.X - 10)
  ElseIf auiMenuItemID == 7 ; Pos Y - 10
	TemperatureWidget.SetYPos(TemperatureWidget.Y - 10)
  ElseIf auiMenuItemID == 8 ; Pos X + 50
	TemperatureWidget.SetXPos(TemperatureWidget.X + 50)
  ElseIf auiMenuItemID == 9 ; Pos Y + 50
	TemperatureWidget.SetYPos(TemperatureWidget.Y + 50)
  ElseIf auiMenuItemID == 10 ; Pos X - 50
	TemperatureWidget.SetXPos(TemperatureWidget.X - 50)
  ElseIf auiMenuItemID == 11 ; Pos Y - 50
	TemperatureWidget.SetYPos(TemperatureWidget.Y - 50)
  ElseIf auiMenuItemID == 12 ; Pos X + 400
	TemperatureWidget.SetXPos(TemperatureWidget.X + 400)
  ElseIf auiMenuItemID == 13 ; Pos Y + 400
	TemperatureWidget.SetYPos(TemperatureWidget.Y + 400)
  ElseIf auiMenuItemID == 14 ; Pos X - 400
	TemperatureWidget.SetXPos(TemperatureWidget.X - 400)
  ElseIf auiMenuItemID == 15 ; Pos Y - 400
	TemperatureWidget.SetYPos(TemperatureWidget.Y - 400)
  EndIf
endEvent


Group Properties
	GUI:TemperatureWidget Property TemperatureWidget Auto
EndGroup
