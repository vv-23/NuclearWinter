ScriptName NuclearWinter:Player:Sprinting extends NuclearWinter:Core:Required
{QUST:NuclearWinter_Player}
import NuclearWinter
import Shared:Log


UserLog Log
CustomEvent OnChanged
int TimerID = 1

; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.FileName = "Player"
	Log.Caller = self
EndEvent


Event OnEnable()
	Player.AddSpell(GasMask_Condition_IsSprinting, false)
	GasMask_Condition_IsSprinting.Cast(none, Player)
	WriteLine(Log, "Added the '"+GasMask_Condition_IsSprinting+"' spell.")
EndEvent


Event OnDisable()
	Player.DispelSpell(GasMask_Condition_IsSprinting)
	Player.RemoveSpell(GasMask_Condition_IsSprinting)
	WriteLine(Log, "Removed the '"+GasMask_Condition_IsSprinting+"' spell.")
EndEvent


; Functions
;---------------------------------------------

	Function InvokeChanged(bool abSprinting)
		var[] arguments = new var[1]
		arguments[0] = abSprinting
		SendCustomEvent("OnChanged", arguments)
	EndFunction

; Properties
;---------------------------------------------

Group Properties
	 Spell Property GasMask_Condition_IsSprinting Auto Const Mandatory
EndGroup
