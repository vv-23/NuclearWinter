;/ Decompiled by Champollion V1.0.6
PEX format v3.9 GameID: 2
Source   : E:\SteamLibrarySSD\steamapps\common\Fallout 4\Data\scripts\Source\FO2287\Shared\Log.psc
Modified : 2017-01-17 00:01:07
Compiled : 2017-01-28 01:29:00
User     : Paul Brown
Computer : DESKTOP-UB11455
/;
ScriptName Shared:Log extends ScriptObject Const hidden

;-- Structs -----------------------------------------
Struct UserLog
	string Caller
	string FileName
EndStruct


;-- Functions ---------------------------------------

Function WriteChangedValue(shared:log:userlog UserLog, string propertyName, var fromValue, var toValue) global
	Shared:Log.WriteLine(UserLog, ("Changing " + propertyName + " from " + fromValue as string + " to " + toValue as string) as var)
EndFunction

bool Function WriteLine(shared:log:userlog UserLog, var text) global
	string defaultFile = "Shared"
	If (UserLog == None)
		UserLog = new shared:log:userlog
		UserLog.Caller = ""
		UserLog.FileName = defaultFile
	ElseIf (shared:papyrus.StringIsNoneOrEmpty(UserLog.FileName))
		UserLog.FileName = defaultFile
	EndIf
	text = (UserLog.Caller + " " + text as string) as var
	return Shared:Log.Write(UserLog.FileName, text as string)
EndFunction

Function WriteMessage(shared:log:userlog UserLog, var text) global
	If (Shared:Log.WriteLine(UserLog, text))
		Debug.MessageBox(text as string)
	EndIf
EndFunction

Function WriteNotification(shared:log:userlog UserLog, var text) global
	If (Shared:Log.WriteLine(UserLog, text))
		Debug.Notification(text as string)
	EndIf
EndFunction

bool Function Write(string FileName, string text) global
	If (Debug.TraceUser(FileName, text, 0))
		return True
	Else
		Debug.OpenUserLog(FileName)
		return Debug.TraceUser(FileName, text, 0)
	EndIf
EndFunction
