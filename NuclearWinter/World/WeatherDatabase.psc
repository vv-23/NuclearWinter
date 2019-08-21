ScriptName NuclearWinter:World:WeatherDatabase extends NuclearWinter:Core:Required
{QUST:NuclearWinter_Context}
import NuclearWinter:Context
import Shared:Log
import Shared:Papyrus

UserLog Log

Entry[] Collection
CustomEvent OnRefreshed

string UpdateState = "UpdateState" const

Struct Entry
	Form FormID = none				;FormID of the weather
	Weather WeatherID = none		;ID of the weather
	int TempClass = -1				;Determines the temperature range of the weather.
	int WindClass = -1				;Determines the wind speed of a weather resulting in wind chill.
	EffectShader Shader = none 		;The Shader that will be applied if certain conditions are met.
EndStruct


; Properties
;---------------------------------------------
Group Shaders
	EffectShader Property Winter_SnowFXS Auto 			;Shader that applies a snow effect to NPC's/Player
	EffectShader Property Winter_HeavySnowFXS Auto		;Shader that applies a heavy snow effect to NPC's/Player
EndGroup

Group Database
	int Property Invalid = -1 AutoReadOnly

	bool Property IsBusy Hidden
		bool Function Get()
			return StateName == UpdateState
		EndFunction
	EndProperty

	int Property Count Hidden
		int Function Get()
			return Collection.Length
		EndFunction
	EndProperty
EndGroup

Group WeatherProperties

	FormList Property Winter_Weather_WeatherID Auto
	
	FormList Property Winter_Weather_Shader_HeavySnowVFX Auto
	FormList Property Winter_Weather_Shader_SnowFXS Auto
	
	FormList Property Winter_Weather_TempClass_Chilly Auto
	FormList Property Winter_Weather_TempClass_Cold Auto
	FormList Property Winter_Weather_TempClass_VeryCold Auto
	FormList Property Winter_Weather_TempClass_ExtremeCold Auto
	FormList Property Winter_Weather_TempClass_ArcticCold Auto
	FormList Property Winter_Weather_TempClass_NuclearCold Auto
	
	FormList Property Winter_Weather_Wind_Calm Auto
	FormList Property Winter_Weather_Wind_LightWind Auto
	FormList Property Winter_Weather_Wind_ModerateBreeze Auto
	FormList Property Winter_Weather_Wind_StrongWind Auto
	FormList Property Winter_Weather_Wind_Gale Auto
	FormList Property Winter_Weather_Wind_WholeGale Auto
	FormList Property Winter_Weather_Wind_Storm Auto
	FormList Property Winter_Weather_Wind_Tempest Auto
EndGroup


; The temperature Class determines the range in which the temperatures will vary for a weather
Group TempClass
	int Property Chilly = 0 AutoReadOnly		;45F	()			to	33F		
	int Property Cold = 1 AutoReadOnly 			;32F 	(0C)		to 	0F		(-17.8C)
	int Property VeryCold = 2 AutoReadOnly		;-1F 	(-18.3C)	to 	-40F	(-40C)
	int Property ExtremeCold = 3 AutoReadOnly 	;-41F 	(-40.6C)	to 	-75F	(-59.4C)
	int Property ArcticCold = 4 AutoReadOnly	;-76F	(-60C)		to	-110F	(-78.9C)
	int Property NuclearCold = 5 AutoReadOnly	;-111F	(-79.4C)	to	-155F	(-103.9C)
EndGroup

; This is an expression of the wind chill effect and will be used to influence the rate of player core temperature calculations
; Wind Chill = 35.74 + 0.6215(Temperature) - 35.75.75(WindSpeed^0.16) + 0.4275(WindSpeed^0.16)
; https://en.wikipedia.org/wiki/Wind_chill#/media/File:Wind_chill.png
; https://www.weather.gov/media/epz/wxcalc/windChill.pdf
; https://www.windows2universe.org/earth/Atmosphere/wind_speeds.html

Group WindClass											; Wind Speed					Wind Chill at -20F (-28.9C) (avg speed)
														;  (kph)		(mph)
	int Property AutoFill = -1 AutoReadOnly														
	int Property Calm = 0 AutoReadOnly					; 	<1 			<0.62			
	int Property LightWind = 1 AutoReadOnly				; 	1-11		0.63-6.84		-32.1F	(-35.6C)
	int Property ModerateBreeze = 2 AutoReadOnly		;	12-28		7.46-17.4		-43F	(-41.7C)	
	int Property StrongWind = 3 AutoReadOnly			;	29-61		18-37.9			-52.2F 	(-46.8C)
	int Property Gale = 4 AutoReadOnly					;	62-88		38.53-54.70		-58.6F	(-50.3C)
	int Property WholeGale = 5 AutoReadOnly				;	89-102		55.3-63.38		-61.8F	(-52.1C)
	int Property Storm = 6 AutoReadOnly					;	103-117		64-72.73		-63.8F	(-53.2C)
	int Property Tempest = 7 AutoReadOnly				;	118-252		73.32-156.6		-70.7F	(-57.1C)
EndGroup


; Events
;---------------------------------------------

Event OnInitialize()
	Log = GetLog(self)
	Log.FileName = "Winter_Weather"
	Collection = new Entry[0]
EndEvent


Event OnEnable()
	ChangeState(self, UpdateState)
	RegisterForRemoteEvent(Player, "OnPlayerLoadGame")
EndEvent


Event OnDisable()
	UnregisterForRemoteEvent(Player, "OnPlayerLoadGame")
EndEvent


Event Actor.OnPlayerLoadGame(Actor akSender)
	ChangeState(self, UpdateState)
EndEvent


; Functions
;---------------------------------------------

Function Add(Entry current)
	{IGNORE}
	WriteLine(Log, "Ignoring request to add '"+EntryToString(current)+"' in '"+StateName+"'.")
EndFunction


int Function GetTemperatureClass(Weather akWeather)
	int index = IndexOf(akWeather)
	If (index > Invalid)
		return Collection[index].TempClass
	Else
		return Invalid
	EndIf
EndFunction

int Function GetWindClass(Weather akWeather)
	int index = IndexOf(akWeather)
	If (index > Invalid)
		return Collection[index].WindClass
	Else
		return Invalid
	EndIf
EndFunction

Form Function GetWeatherFormID(Weather akWeather)
	int index = IndexOf(akWeather)
	If (index > Invalid)
		return Collection[index].FormID
	Else
		return None
	EndIf
EndFunction

EffectShader Function GetEffectShader(Weather akWeather)
	int index = IndexOf(akWeather)
	If (index > Invalid)
		return Collection[index].Shader
	Else
		return None
	EndIf
EndFunction


bool Function Contains(Weather akWeather)
	return IndexOf(akWeather) > Invalid
EndFunction


int Function IndexOf(Weather akWeather)
	If (Collection && akWeather)
		return Collection.FindStruct("WeatherID", akWeather)
	Else
		return Invalid
	EndIf
EndFunction


Weather Function GetAt(int aindex)
	return Collection[aindex].WeatherID
EndFunction


Weather Function GetRandom()
	int index = Utility.RandomInt(0, Count)
	return Collection[index].WeatherID
EndFunction


Entry[] Function GetEntries()
	Entry[] array = new Entry[0]

	int index = 0
	While (index < Collection.Length)
		array.Add(Collection[index])
		index += 1
	EndWhile

	return array
EndFunction


string Function EntryToString(Entry current) Global
	If (current)
		If (current.WeatherID)
			return current.WeatherID
		Else
			return current.FormID
		EndIf
	Else
		return "Invalid Entry"
	EndIf
EndFunction


; Methods
;---------------------------------------------

State UpdateState

	Entry[] Function GetEntries()
		{IGNORE}
		WriteLine(Log, "Ignoring GetEntries in '"+StateName+"'.")
		return none
	EndFunction


	Function Add(Entry current)
		If (current)
			If (current.WeatherID)
				If (Contains(current.WeatherID) == false)
					Collection.Add(current)
					WriteLine(Log, "Added the entry '"+EntryToString(current)+"' to Collection.")
				Else
					WriteLine(Log, "Collection already contains the entry '"+EntryToString(current)+"'.")
				EndIf
			Else
				WriteLine(Log, "The entry '"+EntryToString(current)+"' does not exist or is not of the object type Weather.")
			EndIf
		Else
			WriteLine(Log, "The current entry cannot be none.")
		EndIf
	EndFunction


	Event OnEndState(string asNewState)
		WriteLine(Log, "Sending the OnRefreshed event for collection..")
		SendCustomEvent("OnRefreshed")
	EndEvent


	Event OnBeginState(string asOldState)
		Collection = new Entry[0]
		int i = 0
		While (i < Winter_Weather_WeatherID.GetSize())
			Form WinterWeather = Winter_Weather_WeatherID.GetAt(i)
			Entry WeatherEntry = new Entry
			WeatherEntry.FormID = WinterWeather
			WeatherEntry.WeatherID = Winter_Weather_WeatherID.GetAt(i) as Weather
			; Define the Temperature Class
			If (Winter_Weather_TempClass_Chilly.Find(WinterWeather) != -1)
				WeatherEntry.TempClass = Chilly
			ElseIf (Winter_Weather_TempClass_Cold.Find(WinterWeather) != -1)
				WeatherEntry.TempClass = Cold
			ElseIf (Winter_Weather_TempClass_VeryCold.Find(WinterWeather) != -1)
				WeatherEntry.TempClass = VeryCold
			ElseIf (Winter_Weather_TempClass_ExtremeCold.Find(WinterWeather) != -1)
				WeatherEntry.TempClass = ExtremeCold
			ElseIf (Winter_Weather_TempClass_ArcticCold.Find(WinterWeather) != -1)
				WeatherEntry.TempClass = ArcticCold
			ElseIf (Winter_Weather_TempClass_NuclearCold.Find(WinterWeather) != -1)
				WeatherEntry.TempClass = NuclearCold
			Else
				;No TempClass Defined
				WeatherEntry.TempClass = AutoFill
			EndIf
			; Define the Wind Speed Class
			If (Winter_Weather_Wind_Calm.Find(WinterWeather) != -1)
				WeatherEntry.WindClass = Calm
			ElseIf (Winter_Weather_Wind_LightWind.Find(WinterWeather) != -1)
				WeatherEntry.WindClass = LightWind
			ElseIf (Winter_Weather_Wind_ModerateBreeze.Find(WinterWeather) != -1)
				WeatherEntry.WindClass = ModerateBreeze
			ElseIf (Winter_Weather_Wind_StrongWind.Find(WinterWeather) != -1)
				WeatherEntry.WindClass = StrongWind
			ElseIf (Winter_Weather_Wind_Gale.Find(WinterWeather) != -1)
				WeatherEntry.WindClass = Gale
			ElseIf (Winter_Weather_Wind_WholeGale.Find(WinterWeather) != -1)
				WeatherEntry.WindClass = WholeGale
			ElseIf (Winter_Weather_Wind_Storm.Find(WinterWeather) != -1)
				WeatherEntry.WindClass = Storm
			ElseIf (Winter_Weather_Wind_Tempest.Find(WinterWeather) != -1)
				WeatherEntry.WindClass = Tempest
			Else
				;Auto WindClass Defined
				WeatherEntry.WindClass = AutoFill
			EndIf
			; Define the Shader
			If (Winter_Weather_Shader_HeavySnowVFX.Find(WinterWeather) != -1)
				WeatherEntry.Shader = Winter_HeavySnowFXS
			ElseIf (Winter_Weather_Shader_SnowFXS.Find(WinterWeather) != -1)
				WeatherEntry.Shader = Winter_SnowFXS
			Else
				;No Weather Shader Defined
			EndIf
			Add(WeatherEntry)
			i += 1
		EndWhile
		
		ChangeState(self, EmptyState)
		
	EndEvent
	
EndState
