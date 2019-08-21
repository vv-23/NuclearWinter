;/ Decompiled by Champollion V1.0.6
PEX format v3.9 GameID: 2
Source   : E:\SteamLibrarySSD\steamapps\common\Fallout 4\Data\scripts\Source\FO2287\Shared\Compatibility.psc
Modified : 2017-01-17 00:01:07
Compiled : 2017-01-28 01:28:59
User     : Paul Brown
Computer : DESKTOP-UB11455
/;
ScriptName Shared:Compatibility extends ScriptObject Const hidden

;-- Structs -----------------------------------------
Struct Version
	int Major = 0
	int Minor = 0
	int Build = 0
	int Revision = 0
	bool Distribution = False
EndStruct

Struct ExternalForm
	int FormID
	string PluginFile
EndStruct


;-- Functions ---------------------------------------

bool Function VersionGreaterThan(shared:compatibility:version versionA, shared:compatibility:version versionB) global
	If (versionA.Major > versionB.Major)
		return True
	ElseIf (versionA.Minor > versionB.Minor)
		return True
	ElseIf (versionA.Build > versionB.Build)
		return True
	ElseIf (versionA.Revision > versionB.Revision)
		return True
	Else
		int valueA = shared:papyrus.BoolToInt(versionA.Distribution)
		int valueB = shared:papyrus.BoolToInt(versionB.Distribution)
		If (valueA > valueB)
			return True
		Else
			return False
		EndIf
	EndIf
EndFunction

string Function VersionToString(shared:compatibility:version aVersion) global
	string sDevOnly = ""
	If (aVersion.Distribution)
		sDevOnly = "[REL]"
	Else
		sDevOnly = "[WIP]"
	EndIf
	return aVersion.Major as string + "." + aVersion.Minor as string + "." + aVersion.Build as string + "." + aVersion.Revision as string + " " + sDevOnly
EndFunction

Form Function GetExternalForm(shared:compatibility:externalform aExternalForm) global
	If (Game.IsPluginInstalled(aExternalForm.PluginFile))
		return Game.GetFormFromFile(aExternalForm.FormID, aExternalForm.PluginFile)
	Else
		return None
	EndIf
EndFunction
