Scriptname NuclearWinter:NPC:Cloak extends NuclearWinter:Core:Optional
{QUST:NuclearWinter_NPC}
import Shared:Log

UserLog Log


; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_NPC"
EndEvent

Event OnEnable()
	WriteLine(Log, "Adding the cloak spell '"+Winter_NPC_Cloak+"'' to player.")
	Player.AddSpell(Winter_NPC_Cloak, false)
EndEvent

Event OnDisable()
	WriteLine(Log, "Removing the cloak spell '"+Winter_NPC_Cloak+"'' from player.")
	Player.RemoveSpell(Winter_NPC_Cloak)
EndEvent


; Properties
;---------------------------------------------

Group Properties
	Spell Property Winter_NPC_Cloak Auto Const Mandatory
EndGroup
