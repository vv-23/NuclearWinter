Scriptname NuclearWinter:World:Climate extends NuclearWinter:Core:Optional
{QUST:NuclearWinter_World}
import Shared:Log
import Math

UserLog Log

WeatherData WeatherCurrent
CustomEvent OnWeatherChanged

TransitionData TransitionCurrent
CustomEvent OnWeatherTransition

LocationData LocationCurrent
CustomEvent OnLocationChanged

int ModeValue

int UpdateTimer = 0 const
int UpdateInterval = 30 const

int TransitionTimer = 0 const
int TransitionInterval = 1 const
float TransitionCompleted = 0.7 const

string ChangingState = "ChangingState" const


Struct WeatherData
	Weather Object = none
	int TempClass = 0
	int WindClass = 0
	float AmbientTemp = -1.0
	float WindSpeed = 0.0
EndStruct

Struct TransitionData
	float Completion = -1.0
EndStruct

Struct LocationData
	Location Object = none
	WorldSpace World = none
EndStruct


; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Climate"
	LocationCurrent = new LocationData
	TransitionCurrent = new TransitionData
	WeatherCurrent = new WeatherData
EndEvent


Event OnEnable()
	RegisterForRemoteEvent(Player, "OnLocationChange")
	;RegisterForRemoteEvent(GoodneighborLocation, "OnLocationLoaded")
	;RegisterForRemoteEvent(DiamondCityLocation, "OnLocationLoaded")
EndEvent


Event OnDisable()
	UnregisterForRemoteEvent(Player, "OnLocationChange")
	;UnregisterForRemoteEvent(GoodneighborLocation, "OnLocationLoaded")
	;UnregisterForRemoteEvent(DiamondCityLocation, "OnLocationLoaded")
EndEvent


; Methods
;---------------------------------------------

State ActiveState
	Event OnBeginState(string asOldState)
		WriteLine(Log, "Beginning the '"+ActiveState+"' state from the '"+asOldState+"' state.")
		LocationCurrent = new LocationData
		WeatherCurrent = new WeatherData
		Evaluate()
		StartTimer(UpdateInterval, UpdateTimer)
	EndEvent


	Event OnPlayerTeleport()
		Evaluate()
	EndEvent


	Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
		Evaluate()
	EndEvent


	; Event Location.OnLocationLoaded(Location akSender)
		; If (akSender == GoodneighborLocation)
			; Weather.ReleaseOverride()
		; ElseIf (akSender == DiamondCityLocation)
			; Weather.ReleaseOverride()
		; Else
			; return
		; EndIf
		; WriteLine(Log, "Releasing weather override.")
	; EndEvent


	Event OnTimer(int aiTimerID)
		If (aiTimerID == UpdateTimer)
			Evaluate()
			StartTimer(UpdateInterval, UpdateTimer)
		EndIf
	EndEvent


	Event OnEndState(string asNewState)
		WriteLine(Log, "Ending the '"+ActiveState+"' state for the '"+asNewState+"' state.")

		WeatherCurrent = new WeatherData
		LocationCurrent = new LocationData

		CancelTimer(UpdateTimer)
	EndEvent
EndState


State ChangingState
	Event OnBeginState(string asOldState)
		WriteLine(Log, "Beginning the '"+ChangingState+"' state from the '"+asOldState+"' state.")
		TransitionCurrent = new TransitionData
	EndEvent


	Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
		Evaluate()
	EndEvent


	Event OnPlayerTeleport()
		Evaluate()
	EndEvent


	Event OnTimer(int aiTimerID)
		If (aiTimerID == TransitionTimer)
			float fTransition = Weather.GetCurrentWeatherTransition()

			If (fTransition >= TransitionCompleted)

				If (WeatherChanged())
					WriteLine(Log, "The weather transition has completed.")
					GotoState(ActiveState)
					return
				EndIf

			ElseIf (fTransition > TransitionCurrent.Completion)
				TransitionCurrent.Completion = fTransition
				SendCustomEvent("OnWeatherTransition")
			EndIf

			StartTimer(TransitionInterval, TransitionTimer)
		EndIf
	EndEvent


	Event OnEndState(string asNewState)
		WriteLine(Log, "Ending the '"+ChangingState+"' state for the '"+asNewState+"' state.")
		TransitionCurrent = new TransitionData
	EndEvent
EndState


Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
	{EMPTY}
EndEvent


; Event Location.OnLocationLoaded(Location akSender)
	; {EMPTY}
; EndEvent


; Functions
;---------------------------------------------

Function Evaluate()
	If (LocationChanged())
		WriteLine(Log, "Evaluated a location change.")
	EndIf
	If (WeatherChanged())
		WriteLine(Log, "Evaluated a weather change.")
	EndIf
EndFunction


bool Function LocationChanged()
	Location kLocation = Player.GetCurrentLocation()
	If (kLocation)
		If (kLocation != LocationCurrent.Object)
			LocationCurrent.Object = kLocation
			LocationCurrent.World = Player.GetWorldSpace()
			SendCustomEvent("OnLocationChanged")
			return true
		Else
			WriteLine(Log, "Ignoring, no changes to the current location.")
			return false
		EndIf
	Else
		WriteLine(Log, "Ignoring, the current location is none.")
		return false
	EndIf
EndFunction


bool Function WeatherChanged()
	Weather kWeather = Weather.GetCurrentWeather()
	If (kWeather != None)
		If (kWeather != WeatherCurrent.Object)
			WeatherCurrent.Object = kWeather
			WriteLine(Log, "=============================WeatherChanged==============================")
			WriteLine(Log, "=========================================================================")
			WriteLine(Log, " ")
			WriteLine(Log, " ")
			If WeatherDatabase.Contains(WeatherCurrent.Object) 
				; Get the Ambient Temperature for this weather
				WeatherCurrent.TempClass = WeatherDatabase.GetTemperatureClass(WeatherCurrent.Object)
				If Preset == 0 ; Nuclear Winter Temperature Preset
					If WeatherCurrent.TempClass == 0
						WriteLine(Log, "New weather is Chilly.")
						WeatherCurrent.AmbientTemp = Utility.RandomFloat(33.0, 44.0)
					ElseIf WeatherCurrent.TempClass == 1
						WriteLine(Log, "New weather is Cold.")
						WeatherCurrent.AmbientTemp = Utility.RandomFloat(0.0, 32.0)
					ElseIf WeatherCurrent.TempClass == 2
						WriteLine(Log, "New weather is VeryCold.")
						WeatherCurrent.AmbientTemp = Utility.RandomFloat(-40.0, -1.0)
					ElseIf WeatherCurrent.TempClass == 3
						WriteLine(Log, "New weather is ExtremeCold.")
						WeatherCurrent.AmbientTemp = Utility.RandomFloat(-75.0, -41.0)
					ElseIf WeatherCurrent.TempClass == 4
						WriteLine(Log, "New weather is ArcticCold.")
						WeatherCurrent.AmbientTemp = Utility.RandomFloat(-110.0, -76.0)
					ElseIf WeatherCurrent.TempClass == 5
						WriteLine(Log, "New weather is NuclearCold.")
						WeatherCurrent.AmbientTemp = Utility.RandomFloat(-155.0, -111.0)
					Else
						SetAmbientTemp(kWeather)
					EndIf
				Else ; Realistic Temperature Preset
					If WeatherCurrent.TempClass == 0
						WriteLine(Log, "New weather is Chilly.")
						WeatherCurrent.AmbientTemp = Utility.RandomFloat(33.0, 44.0)
					ElseIf WeatherCurrent.TempClass == 1
						WriteLine(Log, "New weather is Cold.")
						WeatherCurrent.AmbientTemp = Utility.RandomFloat(25.0, 32.0)
					ElseIf WeatherCurrent.TempClass == 2
						WriteLine(Log, "New weather is VeryCold.")
						WeatherCurrent.AmbientTemp = Utility.RandomFloat(10.0, 24.0)
					ElseIf WeatherCurrent.TempClass == 3
						WriteLine(Log, "New weather is ExtremeCold.")
						WeatherCurrent.AmbientTemp = Utility.RandomFloat(5.0, 10.0)
					ElseIf WeatherCurrent.TempClass == 4
						WriteLine(Log, "New weather is ArcticCold.")
						WeatherCurrent.AmbientTemp = Utility.RandomFloat(5.0, 10.0)
					ElseIf WeatherCurrent.TempClass == 5
						WriteLine(Log, "New weather is NuclearCold.")
						WeatherCurrent.AmbientTemp = Utility.RandomFloat(0.0, 5.0)
					Else
						SetRealisticAmbientTemp(kWeather)
					EndIf
				EndIf
				; Apply Difficulty scaler
				If WeatherCurrent.AmbientTemp > 0.0
					WeatherCurrent.AmbientTemp = WeatherCurrent.AmbientTemp / Winter_Difficulty.GetValue()
				Else
					WeatherCurrent.AmbientTemp = WeatherCurrent.AmbientTemp * Winter_Difficulty.GetValue()
				EndIf
				
				; Get the Wind Speed for this weather
				WeatherCurrent.WindClass = WeatherDatabase.GetWindClass(WeatherCurrent.Object)
				If WeatherCurrent.WindClass == 0
					WriteLine(Log, "New weather is Calm.")
					WeatherCurrent.WindSpeed = Utility.RandomFloat(0.0, 0.99)
				ElseIf WeatherCurrent.WindClass == 1
					WriteLine(Log, "New weather has a Light Wind.")
					WeatherCurrent.WindSpeed = Utility.RandomFloat(1.0, 11.0)
				ElseIf WeatherCurrent.WindClass == 2
					WriteLine(Log, "New weather has a Moderate Breeze.")
					WeatherCurrent.WindSpeed = Utility.RandomFloat(12.0, 28.0)
				ElseIf WeatherCurrent.WindClass == 3
					WriteLine(Log, "New weather has Strong Wind.")
					WeatherCurrent.WindSpeed = Utility.RandomFloat(29.0, 61.0)
				ElseIf WeatherCurrent.WindClass == 4
					WriteLine(Log, "New weather has Gale force winds.")
					WeatherCurrent.WindSpeed = Utility.RandomFloat(62.0, 88.0)
				ElseIf WeatherCurrent.WindClass == 5
					WriteLine(Log, "New weather has Whole Gale force winds.")
					WeatherCurrent.WindSpeed = Utility.RandomFloat(89.0, 102.0)
				ElseIf WeatherCurrent.WindClass == 6
					WriteLine(Log, "New weather is a Storm.")
					WeatherCurrent.WindSpeed = Utility.RandomFloat(103.0, 117.0)
				ElseIf WeatherCurrent.WindClass == 7
					WriteLine(Log, "New weather is a Tempest.")
					WeatherCurrent.WindSpeed = Utility.RandomFloat(118.0, 252.0)
				Else
					SetWindSpeed()
				EndIf
				;Change to MPH
				WeatherCurrent.WindSpeed = (WeatherCurrent.WindSpeed * 0.62137)
				WriteLine(Log, "New weather | AmbientTemp: " + WeatherCurrent.AmbientTemp)
				WriteLine(Log, "New weather | WindClass:" + WeatherCurrent.WindClass + " | WindSpeed:" + WeatherCurrent.WindSpeed)
			Else
				;If the weather is unspecified use these to set the temp and windspeed based on weather values
				If Preset == 0
					SetAmbientTemp(kWeather)
				Else
					SetRealisticAmbientTemp(kWeather)
				EndIf
				; Apply Difficulty scaler
				If WeatherCurrent.AmbientTemp > 0.0
					WeatherCurrent.AmbientTemp = WeatherCurrent.AmbientTemp / Winter_Difficulty.GetValue()
				Else
					WeatherCurrent.AmbientTemp = WeatherCurrent.AmbientTemp * Winter_Difficulty.GetValue()
				EndIf
				SetWindSpeed()
				WeatherCurrent.WindSpeed = (WeatherCurrent.WindSpeed * 0.62137)
				WriteLine(Log, "New Unspecified weather | AmbientTemp: " + WeatherCurrent.AmbientTemp)
				WriteLine(Log, "New Unspecified weather | WindClass:" + WeatherCurrent.WindClass + " | WindSpeed:" + WeatherCurrent.WindSpeed)
			EndIf
			SendCustomEvent("OnWeatherChanged")
			WriteLine(Log, " ")
			WriteLine(Log, " ")
			WriteLine(Log, "=========================================================================")
			WriteLine(Log, "=========================================================================")
			return true
		Else
			WriteLine(Log, "Ignoring, no changes to the current weather.")
			return false
		EndIf
	Else
		WriteLine(Log, "Ignoring, the current weather is none.")
		return false
	EndIf
EndFunction

Function SetAmbientTemp(Weather kWeather) ; Nuclear Winter Temperature Preset
	If kWeather.GetClassification() == 0
		WeatherCurrent.AmbientTemp = Utility.RandomFloat(0.0, 32.0)
	ElseIf kWeather.GetClassification() == 1
		WeatherCurrent.AmbientTemp = Utility.RandomFloat(-15.0, 15.0)
	ElseIf kWeather.GetClassification() == 2
		WeatherCurrent.AmbientTemp = Utility.RandomFloat(33.0, 44.0)
	ElseIf kWeather.GetClassification() == 3
		WeatherCurrent.AmbientTemp = Utility.RandomFloat(-40.0, -1.0)
	Else
		WeatherCurrent.AmbientTemp = Utility.RandomFloat(0.00, 32.0)
	EndIf
EndFunction

Function SetRealisticAmbientTemp(Weather kWeather) ; Realistic Winter Temperature Preset
	If kWeather.GetClassification() == 0
		WeatherCurrent.AmbientTemp = Utility.RandomFloat(20.0, 42.0)
	ElseIf kWeather.GetClassification() == 1
		WeatherCurrent.AmbientTemp = Utility.RandomFloat(10.0, 35.0)
	ElseIf kWeather.GetClassification() == 2
		WeatherCurrent.AmbientTemp = Utility.RandomFloat(43.0, 48.0)
	ElseIf kWeather.GetClassification() == 3
		WeatherCurrent.AmbientTemp = Utility.RandomFloat(5.0, 28.0)
	Else
		WeatherCurrent.AmbientTemp = Utility.RandomFloat(10.0, 35.0)
	EndIf
EndFunction


Function SetWindSpeed()
	WeatherCurrent.WindClass = CurrentWindSpeed as Int
	If WeatherCurrent.WindClass == 0
		WriteLine(Log, "New weather is Calm.")
		WeatherCurrent.WindSpeed = Utility.RandomFloat(0.0, 0.99)
	ElseIf WeatherCurrent.WindClass == 1
		WriteLine(Log, "New weather has a Light Wind .")
		WeatherCurrent.WindSpeed = Utility.RandomFloat(1.0, 11.0)
	ElseIf WeatherCurrent.WindClass == 2
		WriteLine(Log, "New weather has a Moderate Breeze.")
		WeatherCurrent.WindSpeed = Utility.RandomFloat(12.0, 28.0)
	ElseIf WeatherCurrent.WindClass == 3
		WriteLine(Log, "New weather has Strong Wind.")
		WeatherCurrent.WindSpeed = Utility.RandomFloat(29.0, 61.0)
	ElseIf WeatherCurrent.WindClass == 4
		WriteLine(Log, "New weather has Gale force winds.")
		WeatherCurrent.WindSpeed = Utility.RandomFloat(62.0, 88.0)
	ElseIf WeatherCurrent.WindClass == 5
		WriteLine(Log, "New weather has Whole Gale force winds.")
		WeatherCurrent.WindSpeed = Utility.RandomFloat(89.0, 102.0)
	ElseIf WeatherCurrent.WindClass == 6
		WriteLine(Log, "New weather is a Storm.")
		WeatherCurrent.WindSpeed = Utility.RandomFloat(103.0, 117.0)
	ElseIf WeatherCurrent.WindClass == 7
		WriteLine(Log, "New weather is a Tempest.")
		WeatherCurrent.WindSpeed = Utility.RandomFloat(118.0, 252.0)
	EndIf
EndFunction
; Properties
;---------------------------------------------

Group Context
	NuclearWinter:World:WeatherDatabase Property WeatherDatabase Auto Const Mandatory
EndGroup


Group Location
	Location Property DiamondCityLocation Auto Const Mandatory
	Location Property GoodneighborLocation Auto Const Mandatory
	GlobalVariable Property Winter_Difficulty Auto
	GlobalVariable Property Winter_TemperatureScale Auto
	GlobalVariable Property Winter_CurrentWindSpeed Auto
	GlobalVariable Property Winter_Preset Auto

	bool Property WasOutside Hidden
		bool Function Get()
			return Player.IsInInterior() == false
		EndFunction
	EndProperty

	bool Property IsInSpecialArea Hidden
		bool Function Get()
			return LocationCurrent.Object \
			&& LocationCurrent.Object == DiamondCityLocation \
			|| LocationCurrent.Object == GoodneighborLocation
		EndFunction
	EndProperty
	
	Int Property Preset Hidden
		Int Function Get()
			return Winter_Preset.GetValueInt()
		EndFunction
	EndProperty
EndGroup


Group Weather
	
	float Property CurrentWindSpeed Hidden
		float Function Get()
			return Winter_CurrentWindSpeed.GetValue()
		EndFunction
	EndProperty

	float Property Transition Hidden
		float Function Get()
			return TransitionCurrent.Completion
		EndFunction
	EndProperty

	int Property WindClass Hidden
		int Function Get()
			return WeatherCurrent.WindClass
		EndFunction
	EndProperty
	
	int Property TempClass Hidden
		int Function Get()
			return WeatherCurrent.TempClass
		EndFunction
	EndProperty
	
	float Property AmbientTemp Hidden
		float Function Get()
			return WeatherCurrent.AmbientTemp
		EndFunction
	EndProperty
	
	float Property WindSpeed Hidden
		float Function Get()
			return WeatherCurrent.WindSpeed
		EndFunction
	EndProperty
	
	Weather Property CurrentWeather Hidden
		Weather Function Get()
			return WeatherCurrent.Object
		EndFunction
	EndProperty
EndGroup
