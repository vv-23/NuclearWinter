ScriptName NuclearWinter:Core:Module extends Form Native Const Hidden
import NuclearWinter:Context
import NuclearWinter:Core:Module
import Shared:Compatibility
import Shared:Log


; Events
;---------------------------------------------

Event OnInit()
	NuclearWinter:Context context = GetInstance()

	If (ModuleInitialize(context, self))
		self.OnInitialize()
		WriteLine(GetLog(self), "The module has initialized.")
	Else
		WriteLine(GetLog(self), "The module could not be initialized.")
	EndIf
EndEvent


Event NuclearWinter:Context.OnStartup(NuclearWinter:Context akSender, var[] arguments)
	self.OnEnable()
	WriteLine(GetLog(self), "The module has finished the OnStartup event.")
EndEvent


Event NuclearWinter:Context.OnShutdown(NuclearWinter:Context akSender, var[] arguments)
	self.OnDisable()
	WriteLine(GetLog(self), "The module has finished the OnShutdown event.")
EndEvent


Event NuclearWinter:Context.OnUpgrade(NuclearWinter:Context akSender, var[] arguments)
	Version newVersion = arguments[0] as Version
	Version oldVersion = arguments[1] as Version
	self.OnUpgrade(newVersion, oldVersion)
	WriteLine(GetLog(self), "The module has finished the OnUpgrade event. " \
		+"New '"+VersionToString(newVersion)+"', Old '"+VersionToString(oldVersion)+"'.")
EndEvent


; Globals
;---------------------------------------------

bool Function ModuleInitialize(NuclearWinter:Context aContext, ScriptObject aModule) Global
	UserLog log = GetLog(aModule)
	If (aModule)
		If (aContext)
			aModule.RegisterForCustomEvent(aContext, "OnStartup")
			aModule.RegisterForCustomEvent(aContext, "OnUpgrade")
			aModule.RegisterForCustomEvent(aContext, "OnShutdown")
			return true
		Else
			WriteLine(log, "Cannot initialize a module with a none context.")
			return false
		EndIf
	Else
		WriteLine(log, "Cannot initialize a module with a none ScriptObject.")
		return false
	EndIf
EndFunction


; Virtual
;---------------------------------------------

Event OnInitialize()
	{VIRTUAL}
	WriteLine(GetLog(self), "The module has not implemented the virtual OnInitialize event.")
EndEvent

Event OnEnable()
	{VIRTUAL}
	WriteLine(GetLog(self), "The module has not implemented the virtual OnEnable event.")
EndEvent

Event OnDisable()
	{VIRTUAL}
	WriteLine(GetLog(self), "The module has not implemented the virtual OnDisable event.")
EndEvent

Event OnUpgrade(Version aNew, Version aPrevious)
	{VIRTUAL}
	WriteLine(GetLog(self), "The module has not implemented the virtual OnUpgrade event for version '"+VersionToString(aNew)+"'.")
EndEvent


; Properties
;---------------------------------------------

Group Module
	string Property StateName Hidden
		string Function Get()
			return GetState()
		EndFunction
	EndProperty

	string Property EmptyState = "" AutoReadOnly
EndGroup
