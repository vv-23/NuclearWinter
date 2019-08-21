Scriptname NuclearWinter:ContextWidget extends NuclearWinter:GUI:HUDWidget
import NuclearWinter:Context
import Shared:Compatibility
import Shared:Log

UserLog Log

int Command_UpdateAuthors = 100 const
string Command_UpdateTitle = "UpdateTitle" const
string Command_UpdateVersion = "UpdateVersion" const


; Events
;---------------------------------------------

Event OnInitialize()
	Log = GetLog(self)
EndEvent


Event OnEnable()
	Load()
EndEvent


Event OnDisable()
	Unload()
EndEvent


Event OnWidgetLoaded()
	SendText(Command_UpdateTitle, Context.Title)
	SendText(Command_UpdateVersion, VersionToString(Context.Release))
	; SendNumber(Command_UpdateAuthors, Context.Authors.Length)
EndEvent


; Methods
;---------------------------------------------

WidgetData Function Create()
	WidgetData widget = new WidgetData
	widget.ID = "ContextWidget.swf"
	widget.LoadNow = true
	widget.AutoLoad = true
	widget.X = 850
	widget.Y = 550
	return widget
EndFunction
