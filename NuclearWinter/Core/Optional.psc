ScriptName NuclearWinter:Core:Optional extends NuclearWinter:Core:Module Hidden
import NuclearWinter:Context
import NuclearWinter:Core:Module
import Shared:Compatibility
import Shared:Log
import Shared:Papyrus

UserLog Log

bool EnabledValue
Actor PlayerReference


; Events
;---------------------------------------------

Event OnInit()
	Log = GetLog(self)
	PlayerReference = Game.GetPlayer()
	EnabledValue = true
	parent.OnInit()
EndEvent


Event NuclearWinter:Context.OnStartup(NuclearWinter:Context akSender, var[] arguments)
	If (SetActive(self))
		OnEnable()
		WriteLine(Log, "The module has finished the OnStartup event.")
	Else
		WriteLine(Log, "The module could not finish the OnStartup event.")
	EndIf
EndEvent


Event NuclearWinter:Context.OnShutdown(NuclearWinter:Context akSender, var[] arguments)
	If (SetActive(self, false))
		OnDisable()
		WriteLine(Log, "The module has finished the OnShutdown event.")
	Else
		WriteLine(Log, "The module could not finish the OnShutdown event.")
	EndIf
EndEvent


Event NuclearWinter:Context.OnUpgrade(NuclearWinter:Context akSender, var[] arguments)
	If (Enabled)
		Version newVersion = arguments[0] as Version
		Version oldVersion = arguments[1] as Version
		self.OnUpgrade(newVersion, oldVersion)
		WriteLine(Log, "The module has finished the OnUpgrade event. " \
			+"New '"+VersionToString(newVersion)+"', Old '"+VersionToString(oldVersion)+"'.")
	Else
		WriteLine(Log, "Ignoring the OnUpgrade event, module is not enabled.")
	EndIf
EndEvent


; Functions
;---------------------------------------------

bool Function SetActive(Optional aOptional, bool abActive = true) Global
	UserLog lg = GetLog(aOptional)
	string sEmptyState = "" const
	string sActiveState = "ActiveState" const

	If (aOptional)
		If (abActive) ; requested active state
			If (HasState(aOptional)) ; already activated
				WriteLine(lg, "Ignoring request for ActiveState, module is already active.")
				return false
			Else
				If (ChangeState(aOptional, sActiveState))
					WriteLine(lg, "The module has finished enabling.")
					return true
				Else
					WriteLine(lg, "The module could not be enabled.")
					return false
				EndIf
			EndIf
		Else ; requested empty state
			If (aOptional.GetState() == sEmptyState) ; already deactivated
				WriteLine(lg, "Ignoring request for EmptyState, module is already deactivated.")
				return false
			Else
				If (ChangeState(aOptional, sEmptyState))
					WriteLine(lg, "The module has finished disabling.")
					return true
				Else
					WriteLine(lg, "The module could not be disabled.")
					return false
				EndIf
			EndIf
		EndIf
	Else
		WriteLine(lg, "Cannot change ActiveState on a none script object.")
		return false
	EndIf
EndFunction


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

Group Module
	bool Property IsReady Hidden
		bool Function Get()
			return EnabledValue && HasState(self)
		EndFunction
	EndProperty

	bool Property Enabled Hidden
		bool Function Get()
			return EnabledValue
		EndFunction
		Function Set(bool aValue)
			If (aValue != EnabledValue)
				EnabledValue = aValue
				WriteChangedValue(Log, "Enabled", !aValue, aValue)
				SetActive(self, aValue)
			Else
				WriteLine(Log, "The module's Enabled property already equals '"+aValue+"'.")
			EndIf
		EndFunction
	EndProperty

	string Property ActiveState = "ActiveState" AutoReadOnly
EndGroup
