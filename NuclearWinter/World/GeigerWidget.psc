Scriptname NuclearWinter:World:GeigerWidget extends NuclearWinter:GUI:HUDWidget
import NuclearWinter
import NuclearWinter:Context
import Shared:Log

UserLog Log
Actor Player

int Command_UpdateRadiation = 300 const
int Command_UpdateGeiger = 400 const


; Events
;---------------------------------------------

Event OnEnable()
	Load()
	RegisterForRadiationDamageEvent(Player)
	RegisterForCustomEvent(Radiation, "OnChanged")
EndEvent


Event OnDisable()
	Unload()
	UnregisterForRadiationDamageEvent(Player)
	UnregisterForCustomEvent(Radiation, "OnChanged")
EndEvent


Event NuclearWinter:World:Radiation.OnChanged(World:Radiation akSender, var[] arguments)
	WriteLine(Log, "Updated widget for changed ambient radiation.")
	SendNumber(Command_UpdateGeiger, Radiation.Exposure)
EndEvent


Event OnRadiationDamage(ObjectReference akTarget, bool abIngested)
	WriteLine(Log, "OnRadiationDamage(akTarget="+akTarget+", abIngested="+abIngested+")")

	SendNumber(Command_UpdateRadiation, 99)

	Utility.Wait(3)
	RegisterForRadiationDamageEvent(Player)
EndEvent


; Methods
;---------------------------------------------

WidgetData Function Create()
	WidgetData widget = new WidgetData
	widget.ID = "GeigerWidget.swf"
	widget.X = 10
	widget.Y = 10
	return widget
EndFunction


; Properties
;---------------------------------------------

Group Context
	World:Radiation Property Radiation Auto Const Mandatory
EndGroup
