ScriptName NuclearWinter:Context extends Quest
import Shared:Compatibility
import Shared:Log

UserLog Log
Version LastVersion

CustomEvent OnStartup
CustomEvent OnUpgrade
CustomEvent OnShutdown

int StartingTimer = 1

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Title
	Activated = false
	LastVersion = Release
	RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
	RegisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
	;If(HasHolotape == false)
		;Game.GetPlayer().AddItem(Winter_ContextHolotape, 1)
	;EndIf
	WriteLine(Log, "OnInit")
EndEvent


Event OnQuestInit()
	WriteLine(Log, "OnQuestInit")
	IsActivated = true
EndEvent


Event OnStageSet(int auiStageID, int auiItemID)
	WriteLine(Log, "Quest.OnStageSet")
	IsActivated = true
EndEvent


Event Actor.OnPlayerLoadGame(Actor akSender)
	WriteLine(Log, "Reloaded "+Title+" version "+VersionToString(Release))
	Version versionNew = Release
	Version versionPrevious = LastVersion
	; If(HasHolotape == false)
		; Game.GetPlayer().AddItem(Winter_ContextHolotape, 1)
	; EndIf
	If (VersionGreaterThan(versionNew, versionPrevious))
		WriteChangedValue(Log, "Version", versionPrevious, versionNew)
		LastVersion = versionNew
		var[] arguments = new var[2]
		arguments[0] = versionNew
		arguments[1] = versionPrevious
		SendCustomEvent("OnUpgrade", arguments)
	Else
		WriteLine(Log, "No version change so doing nothing at all..")
	EndIf
EndEvent

Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
	If (akNewLoc != PreWarSanctuary && akNewLoc != PreWarVault111)
		WriteLine(Log, "Leaving PreWarSanctuary, Activating...")
		If (IsActivated) 
			UnregisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
		Else
			IsActivated = True
			UnregisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
		EndIf
	EndIf
EndEvent

Event OnTimer(int aiTimerID)
	If aiTimerID == StartingTimer
		If (IsActivated) 
			UnregisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
		Else
			IsActivated = True
			UnregisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
		EndIf
	EndIf
EndEvent




; Globals
;---------------------------------------------

string Function GetTitle() Global
	return "Nuclear Winter"
EndFunction


string Function GetPlugin() Global
	return "Nuclear Winter.esp"
EndFunction


int Function GetEditorID() Global
	return 0x00000FB4
EndFunction


Context Function GetInstance() Global
	ExternalForm contextInstance = new ExternalForm
	contextInstance.FormID = GetEditorID()
	contextInstance.PluginFile = GetPlugin()
	return GetExternalForm(contextInstance) as Context
EndFunction


UserLog Function GetLog(ScriptObject aScriptObject) Global DebugOnly
	UserLog contextLog = new UserLog
	contextLog.Caller = aScriptObject
	contextLog.FileName = GetTitle()
	return contextLog
EndFunction

; Functions
;---------------------------------------------

Function SetActivation(bool value)
	IsActivated = value
EndFunction

Function Preset(int choice)

EndFunction

; Properties
;---------------------------------------------

Group Context
	string Property Title Hidden
		string Function Get()
			return GetTitle()
		EndFunction
	EndProperty

	string[] Property Authors Hidden
		string[] Function Get()
			string[] strings = new string[1]
			strings[0] = "D1v1ne122"
			return strings
		EndFunction
	EndProperty

	string Property Plugin Hidden
		string Function Get()
			return GetPlugin()
		EndFunction
	EndProperty

	int Property EditorID Hidden
		int Function Get()
			return GetEditorID()
		EndFunction
	EndProperty

	Version Property Release Hidden
		Version Function Get()
			Version ver = new Version
			ver.Distribution = false
			ver.Major = 1
			ver.Minor = 0
			ver.Build = 0
			ver.Revision = 0
			return ver
		EndFunction
	EndProperty
EndGroup


Group Conditions
	Quest property MQ102 Auto Const Mandatory
	Location property PreWarSanctuary Auto Const Mandatory
	Location property PreWarVault111 Auto Const Mandatory
	
	bool property Activated Auto
	
	bool Property IsReady Hidden
		bool Function Get()
			return (MQ102.IsStageDone(1) || (Game.GetPlayer().GetCurrentLocation() != PreWarSanctuary && Game.GetPlayer().GetCurrentLocation() != PreWarVault111))
		EndFunction
	EndProperty

	bool Property IsActivated Hidden
		bool Function Get()
			return Activated
		EndFunction
		Function Set(bool aValue)
			If (Activated == aValue)
				WriteLine(Log, "Activated is already equal to "+aValue)
				return
			Else
				If (IsReady)
					Activated = aValue
					Winter_Activated.SetValueInt(Activated as Int)
					If (aValue)
						WriteNotification(Log, Title+" is starting..")
						;If(HasHolotape == false)
							;Game.GetPlayer().AddItem(Winter_ContextHolotape, 1)
						;EndIf
						Game.GetPlayer().AddItem(Winter_InsulationToggle, 2)
						Game.GetPlayer().AddItem(Winter_SettingsHolotape, 1)
						SendCustomEvent("OnStartup")
						Equipment.SetInsulation()
					Else
						WriteNotification(Log, Title+" is shutting down.")
						SendCustomEvent("OnShutdown")
					EndIf
					UnregisterForRemoteEvent(MQ102, "OnStageSet")
				Else
					WriteLine(Log, Title+" is not ready.")
					RegisterForRemoteEvent(MQ102, "OnStageSet")
				EndIf
			EndIf
		EndFunction
	EndProperty
EndGroup



Group Properties
	Gear:Equipment Property Equipment Auto
	Message Property Winter_StartMessage Auto
	;Holotape Property Winter_ContextHolotape Auto Const
	Potion Property Winter_InsulationToggle Auto Const
	Holotape Property Winter_SettingsHolotape Auto
	GlobalVariable Property Winter_Activated Auto
EndGroup

; Group Setup
	; bool Property HasHolotape Hidden
		; bool Function Get()
			; return Game.GetPlayer().GetItemCount(Winter_ContextHolotape) >= 1
		; EndFunction
	; EndProperty
; EndGroup
