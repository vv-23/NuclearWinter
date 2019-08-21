ScriptName NuclearWinter:Gear:DetectExplosionSmall extends ObjectReference
import NuclearWinter 
import Shared:Log

UserLog Log
Actor Player
float distance = 100.0
ObjectReference Marker

Event Onload()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Mask Wipe"
	
	WriteLine(Log, "Explosion Detected...")
	Marker = self
	Player = Game.GetPlayer()
	If(Marker.GetDistance(Player) <= distance)
		WriteLine(Log, "Within Distance, adding mud...")
		MaskWipe.MudUpdate(true)
	EndIf
	Self.disable(False)
	Self.delete()
EndEvent

; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Gear:MaskWipe Property MaskWipe Auto Const Mandatory
EndGroup
