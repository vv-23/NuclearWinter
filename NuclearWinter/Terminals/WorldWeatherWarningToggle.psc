ScriptName NuclearWinter:Terminals:WorldWeatherWarningToggle extends Terminal
import Shared:Log

UserLog Log

int WeatherWarningToggle = 2 const
int WeatherWarningMessage = 3 const
int TurnOFF = 4 const
CustomEvent OnChanged
; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
 
	If(auiMenuItemID == WeatherWarningToggle)
		If(ClimateReader.SFXOn == false)
			ClimateReader.SFXOn = true
			Debug.Notification("Climate Reader SFX Toggled On")
		Else
			ClimateReader.SFXOn = false
			Debug.Notification("Climate Reader SFX Toggled Off")
		EndIf
	ElseIf(auiMenuItemID == WeatherWarningMessage)
		If(ClimateReader.MessageOn == false)
			ClimateReader.MessageOn = true
			Debug.Notification("Message VFX Toggled On")
		Else
			ClimateReader.MessageOn = false
			Debug.Notification("Message VFX Toggled Off")
		EndIf
	ElseIf(auiMenuItemID == TurnOFF)
		If(ClimateReader.ClimateReaderOn == false)
			ClimateReader.ClimateReaderOn = true
			Debug.Notification("Climate Reader Turned On")
		Else
			ClimateReader.ClimateReaderOn = false
			Debug.Notification("Climate Reader Turned Off")
		EndIf
		SendCustomEvent("OnChanged")
    EndIf
	
EndEvent


; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Context Property Context Auto Const Mandatory
	NuclearWinter:World:ClimateReader Property ClimateReader Auto Const Mandatory
EndGroup
