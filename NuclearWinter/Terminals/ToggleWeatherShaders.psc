ScriptName NuclearWinter:Terminals:ToggleWeatherShaders extends NuclearWinter:Core:Required

import Shared:Log
import NuclearWinter
import NuclearWinter:World

UserLog Log
CustomEvent OnToggle

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent

Function Toggle()
	Utility.Wait(1.0)
	WeatherShader.Toggle()
	SendCustomEvent("OnToggle")
	Writeline(Log, "Weather Shaders Toggled " + WeatherShaderToggle)
EndFunction

World:WeatherShader Property WeatherShader Auto Const
Bool Property WeatherShaderToggle Auto 
