ScriptName NuclearWinter:Terminals:GearFilterInterval extends Terminal
import NuclearWinter
import Shared:Log

UserLog Log
Option[] Options

Struct Option
	string Text
	int MenuItemID
	int Value
EndStruct


; Events
;---------------------------------------------

Event OnInIt()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
	Options = new Option[0]

	Option option1 = new Option
	option1.MenuItemID = 2
	option1.Text = "Your gas mask filters will last 1min 40sec."
	option1.Value = 10
	Options.Add(option1)

	Option option2 = new Option
	option2.MenuItemID = 3
	option2.Text = "Your gas mask filters will last 3min 20sec."
	option2.Value = 20
	Options.Add(option2)

	Option option3 = new Option
	option3.MenuItemID = 4
	option3.Text = "Your gas mask filters will last 5min."
	option3.Value = 30
	Options.Add(option3)

	Option option4 = new Option
	option4.MenuItemID = 5
	option4.Text = "Your gas mask filters will last 6min 40sec ."
	option4.Value = 40
	Options.Add(option4)

	Option option5 = new Option
	option5.MenuItemID = 6
	option5.Text = "Your gas mask filters will last 8min 20sec."
	option5.Value = 50
	Options.Add(option5)

	Option option6 = new Option
	option6.MenuItemID = 7
	option6.Text = "Your gas mask filters will last 10min."
	option6.Value = 60
	Options.Add(option6)

	Option option7 = new Option
	option7.MenuItemID = 8
	option7.Text = "Your gas mask filters will last for 11min 66sec."
	option7.Value = 70
	Options.Add(option7)
	
	Option option8 = new Option
	option8.MenuItemID = 9
	option8.Text = "Your gas mask filters will last for 20."
	option8.Value = 120
	Options.Add(option8)
EndEvent



Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
	If (auiMenuItemID == 1)
		return
	Else
		int index = Options.FindStruct("MenuItemID", auiMenuItemID)
		SetOption(Options[index])
	EndIf
EndEvent


; Functions
;---------------------------------------------

Function SetOption(Option aOption)
	If (aOption)
		int current = Filter.Interval
		Filter.Interval = aOption.Value
		WriteChangedValue(Log, aOption.Text, current, aOption.Value)
	EndIf
EndFunction


; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Context Property Context Auto Const Mandatory
	Gear:Filter Property Filter Auto Const Mandatory
EndGroup
