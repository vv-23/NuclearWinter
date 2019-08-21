ScriptName NuclearWinter:ContextSetup extends NuclearWinter:Core:Required
import NuclearWinter:Context
import Shared:Log

UserLog Log


; Events
;---------------------------------------------
Event OnInitialize()
	Log = GetLog(self)
EndEvent


Event OnEnable()
	If (TryAdd())
		WriteLine(Log, "Added a holotape to the player for startup.")
	Else
		WriteLine(Log, "The player already has a holotape for startup.")
	EndIf
EndEvent


Event OnDisable()
	If (TryAdd()) ; so player can enable the mod again
		WriteLine(Log, "Added a holotape to the player for shutdown.")
	Else
		WriteLine(Log, "The player already has a holotape for shutdown.")
	EndIf
EndEvent


; Functions
;---------------------------------------------

bool Function TryAdd()
	If (HasHolotape == false)
		Player.AddItem(Winter_ContextHolotape, 1)
		return true
	Else
		return false
	EndIf
EndFunction


; Properties
;---------------------------------------------

Group Properties
	Holotape Property Winter_ContextHolotape Auto Const Mandatory
EndGroup

Group Setup
	bool Property HasHolotape Hidden
		bool Function Get()
				return Player.GetItemCount(Winter_ContextHolotape) >= 1
		EndFunction
	EndProperty
EndGroup
