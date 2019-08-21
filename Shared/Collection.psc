;/ Decompiled by Champollion V1.0.6
PEX format v3.9 GameID: 2
Source   : E:\SteamLibrarySSD\steamapps\common\Fallout 4\Data\scripts\Source\FO2287\Shared\Collection.psc
Modified : 2017-01-17 00:01:07
Compiled : 2017-01-28 01:28:59
User     : Paul Brown
Computer : DESKTOP-UB11455
/;
ScriptName Shared:Collection extends ScriptObject Const hidden

;-- Functions ---------------------------------------

var[] Function GetDistinct(var[] aArray) global
	var[] distinct = new var[0]
	int index = 0
	While (index < aArray.length)
		var element = aArray[index]
		If (distinct.find(element, 0) == -1)
			distinct.add(element, 1)
		EndIf
		index += 1
	EndWhile
	return distinct
EndFunction
