;/ Decompiled by Champollion V1.0.6
PEX format v3.9 GameID: 2
Source   : E:\SteamLibrarySSD\steamapps\common\Fallout 4\Data\scripts\Source\FO2287\Shared\Papyrus.psc
Modified : 2017-01-17 00:01:07
Compiled : 2017-01-28 01:29:00
User     : Paul Brown
Computer : DESKTOP-UB11455
/;
ScriptName Shared:Papyrus extends ScriptObject Const hidden

;-- Structs -----------------------------------------
Struct Point
	float X = 0
	float Y = 0
	float Z = 0
EndStruct


;-- Functions ---------------------------------------

bool Function ChangeState(ScriptObject aScriptObject, string asNewState) global
	string stateName = aScriptObject.GetState()
	If (stateName != asNewState)
		aScriptObject.GoToState(asNewState)
		return True
	Else
		return False
	EndIf
EndFunction

bool Function StringIsNoneOrEmpty(string value) global
	return !value || value == ""
EndFunction

bool Function HasState(ScriptObject aScriptObject) global
	return aScriptObject.GetState() != ""
EndFunction

int Function BoolToInt(bool value) global
	If (value)
		return 1
	Else
		return 0
	EndIf
EndFunction

string Function PointToString(shared:papyrus:point value) global
	return "X:" + value.X as string + ", Y:" + value.Y as string + ", Z:" + value.Z as string
EndFunction
