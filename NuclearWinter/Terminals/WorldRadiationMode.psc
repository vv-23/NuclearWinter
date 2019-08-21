ScriptName NuclearWinter:Terminals:WorldRadiationMode extends Terminal
import Shared:Log

UserLog Log
CustomEvent OnChanged

int OptionPrecipitation = 2 const
int OptionRadiation = 3 const
int OptionNormal = 4 const
int OptionNoRads = 5 const


; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
    If (auiMenuItemID == OptionPrecipitation)
		Radiation.WeatherOnly = true
		Radiation.RadWeatherOnly = false
		Radiation.NoRadiation = false
		WriteLine(Log, "Precipitation Only Activated")
		SendCustomEvent("OnChanged")
	ElseIf(auiMenuItemID == OptionRadiation)
		WriteLine(Log, "Heavy Weather Only Activated")
		Radiation.RadWeatherOnly = true
		Radiation.WeatherOnly = false
		Radiation.NoRadiation = false
		SendCustomEvent("OnChanged")
	ElseIf(auiMenuItemID == OptionNormal)
		Radiation.NoRadiation = false
		Radiation.WeatherOnly = false
		Radiation.RadWeatherOnly = false
		WriteLine(Log, "Normal Activated")
		SendCustomEvent("OnChanged")
	ElseIf(auiMenuItemID == OptionNoRads)
		Radiation.NoRadiation = true
		Radiation.WeatherOnly = false
		Radiation.RadWeatherOnly = false
		WriteLine(Log, "Normal Activated")
		SendCustomEvent("OnChanged")
    EndIf
	
EndEvent


; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Context Property Context Auto Const Mandatory
	NuclearWinter:World:Radiation Property Radiation Auto Const Mandatory
EndGroup
