ScriptName NuclearWinter:Player:Camera extends NuclearWinter:Core:Required
{QUST:NuclearWinter_Player}
import Shared:Log


UserLog Log
CustomEvent OnChanged


; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.FileName = "Player"
	Log.Caller = self
EndEvent


Event OnEnable()
	Player.AddSpell(GasMask_Condition_IsFirstPerson, false)
	GasMask_Condition_IsFirstPerson.Cast(none, Player)
	WriteLine(Log, "Added the '"+GasMask_Condition_IsFirstPerson+"' spell.")
EndEvent


Event OnDisable()
	Player.DispelSpell(GasMask_Condition_IsFirstPerson)
	Player.RemoveSpell(GasMask_Condition_IsFirstPerson)
	WriteLine(Log, "Removed the '"+GasMask_Condition_IsFirstPerson+"' spell.")
EndEvent


; Functions
;---------------------------------------------

Function InvokeChanged(bool abFirstPerson)
	;WriteMessage(Log, "InvokeChanged(abFirstPerson='"+abFirstPerson+"')")

	var[] arguments = new var[1]
	arguments[0] = abFirstPerson 
	self.SendCustomEvent("OnChanged", arguments)
EndFunction


; Properties
;---------------------------------------------

Group Properties
	Spell Property GasMask_Condition_IsFirstPerson Auto Const Mandatory
EndGroup


Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Player.GetAnimationVariableBool("IsFirstPerson")
		EndFunction
	EndProperty
EndGroup
