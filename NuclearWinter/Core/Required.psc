ScriptName NuclearWinter:Core:Required extends NuclearWinter:Core:Module Hidden


Actor PlayerReference


; Events
;---------------------------------------------

Event OnInit()
	PlayerReference = Game.GetPlayer()
	parent.OnInit()
EndEvent


; Properties
;---------------------------------------------

Group Context
	NuclearWinter:Context Property Context Auto Const Mandatory
EndGroup


Group Properties
	Actor Property Player Hidden
		Actor Function Get()
			return PlayerReference
		EndFunction
	EndProperty
EndGroup
