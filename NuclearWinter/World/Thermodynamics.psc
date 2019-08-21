Scriptname NuclearWinter:World:Thermodynamics extends NuclearWinter:Core:Optional
{QUST:NuclearWinter_World}
import NuclearWinter
import NuclearWinter:World
import Shared:Log
import Math

UserLog Log
CustomEvent OnChanged
CustomEvent OnThreshold

float DisabledTemperature = 98.5

bool first = true
bool WasInInterior = false

float UpdateInterval
float InWeatherPerc
float OutWeatherPerc

float TargetTemperature
float TargetWindSpeed
float TimeOfDayTempModifier

float SleepStartTime
float SleepStopTime

float RecentRateofChange

int TempTimer = 0 const
int WindTimer = 1 const
int CalcTimer = 2 const
;int SFXTimer = 3 const
int WetTimer = 4 const
int TimeOfDayTimer = 5 const

var[] params


; Events
;==========================================================================================

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Thermodynamics"
EndEvent


Event OnEnable()
	RegisterForPlayerWait()
	RegisterForPlayerSleep() 
	RegisterForCustomEvent(Equipment, "OnChanged")
	RegisterForCustomEvent(Climate, "OnWeatherTransition")
	RegisterForCustomEvent(Climate, "OnWeatherChanged")
	RegisterForCustomEvent(Climate, "OnLocationChanged")
	RegisterForCustomEvent(DetectInteriors,"OnEnterInterior")
	RegisterForCustomEvent(DetectInteriors,"OnExitInterior")
	CoreTemperature = DisabledTemperature
	TargetTemperature = 0
	TargetWindSpeed = 0
	GotoState("ActiveState")
EndEvent


Event OnDisable()
	CancelTimer(CalcTimer)
	CancelTimer(WetTimer)
	CancelTimer(WindTimer)
	CancelTimerGameTime(TimeOfDayTimer)
	UnRegisterForPlayerWait()
	UnRegisterForPlayerSleep() 
	UnregisterForCustomEvent(Equipment, "OnChanged")
	UnregisterForCustomEvent(Climate, "OnWeatherTransition")
	UnregisterForCustomEvent(Climate, "OnWeatherChanged")
	UnregisterForCustomEvent(Climate, "OnLocationChanged")
	UnRegisterForCustomEvent(DetectInteriors,"OnEnterInterior")
	UnRegisterForCustomEvent(DetectInteriors,"OnExitInterior")
	DisabledTemperature = CoreTemperature
	Temperature = 0
	WindSpeed = 0
	TargetTemperature = 0
	TargetWindSpeed = 0
	GoToState("")
EndEvent

; Thermodynamic Events/Functions
;==========================================================================================
State ActiveState
	Event OnBeginState(string asOldState)
		WriteLine(Log, "Beginning the ActiveState from the '"+asOldState+"'.")
		StartTimer(2,CalcTimer)
		StartTimerGameTime(0.1,TimeOfDayTimer)
	EndEvent

	Event NuclearWinter:Gear:Equipment.OnChanged(Gear:Equipment akSender, var[] arguments)
		WriteLine(Log, "Thermodynamic: Equipment.OnChanged")
		CalcTemperatureChange()
	EndEvent


	Event NuclearWinter:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
		WriteLine(Log, "Thermodynamic: OnLocationChanged")
		If (Player.IsInInterior())
			Utility.Wait(0.5)
			WasInInterior = true
			WriteLine(Log, "Player Inside, changing temperature.")
			CalcTemperatureChange()
		ElseIf WasInInterior == true
			Utility.Wait(0.5)
			WasInInterior = false
			CalcTemperatureChange()
			;Temperature = TargetTemperature + 3
			;If TargetWindSpeed > 5
			;	WindSpeed = TargetWindSpeed - 3
			;EndIf
		EndIf
	EndEvent


	Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		WriteLine(Log, "Thermodynamic: OnWeatherChanged")
		CalcTemperatureChange()
	EndEvent
	
	Event NuclearWinter:Gear:DetectInteriors.OnEnterInterior(Gear:DetectInteriors akSender, var[] arguments)
		WriteLine(Log, "Thermodynamic: OnEnterFakeInterior")
		CalcTemperatureChange()
		;Temperature = TargetTemperature - 3
		;WindSpeed = TargetWindSpeed
	EndEvent

	Event NuclearWinter:Gear:DetectInteriors.OnExitInterior(Gear:DetectInteriors akSender, var[] arguments)
		WriteLine(Log, "Thermodynamic: OnExitFakeInterior")
		CalcTemperatureChange()
		;Temperature = TargetTemperature + 3
		;If TargetWindSpeed > 5
		;	WindSpeed = TargetWindSpeed - 3
		;EndIf
	EndEvent
	
	Event OnPlayerSleepStart(float afSleepStartTime, float afDesiredSleepEndTime, ObjectReference akBed)
		SleepStartTime = Utility.GetCurrentGameTime()
	EndEvent
	
	Event OnPlayerSleepStop(bool abInterrupted, ObjectReference akBed)
		If (IsInWarmLocation == true || HeatSource.IsInHeatSource == true)
			SleepStopTime = Utility.GetCurrentGameTime()
			; Difference is the number of hours between the start and end time
			float Difference = (SleepStopTime - SleepStartTime) * 24
			Coretemperature = CoreTemperature + (3.69 * Difference)
			If(CoreTemperature > 99.8)
				CoreTemperature = 99.8
			EndIf
			SendCustomEvent("OnChanged")
		ElseIf (Player.GetItemCount(Winter_Blanket) > 0)
			SleepStopTime = Utility.GetCurrentGameTime()
			float Difference = (SleepStopTime - SleepStartTime) * 24
			Coretemperature = CoreTemperature + (((RecentRateofChange + 0.2) * 6) * Difference)
			If(CoreTemperature > 99.8)
				CoreTemperature = 99.8
			EndIf
			Winter_Blanket_MSG.show()
			SendCustomEvent("OnChanged")
		Else
			SleepStopTime = Utility.GetCurrentGameTime()
			float Difference = (SleepStopTime - SleepStartTime) * 24
			Coretemperature = CoreTemperature + ((RecentRateofChange * 6) * Difference)
			If(CoreTemperature > 99.8)
				CoreTemperature = 99.8
			EndIf
			SendCustomEvent("OnChanged")
		EndIf
	EndEvent
	
	Event OnPlayerWaitStart(float afWaitStartTime, float afDesiredWaitEndTime)
		SleepStartTime = Utility.GetCurrentGameTime()
	EndEvent
	
	 
	Event OnPlayerWaitStop(bool abInterrupted)
		If (IsInWarmLocation == true || HeatSource.IsInHeatSource == true)
			SleepStopTime = Utility.GetCurrentGameTime()
			float Difference = (SleepStopTime - SleepStartTime) * 24
			Coretemperature = CoreTemperature + (3.69 * Difference)
			If(CoreTemperature > 99.8)
				CoreTemperature = 99.8
			EndIf
			SendCustomEvent("OnChanged")
		ElseIf (Player.GetItemCount(Winter_Blanket) > 0)
			SleepStopTime = Utility.GetCurrentGameTime()
			float Difference = (SleepStopTime - SleepStartTime) * 24
			Coretemperature = CoreTemperature + (((RecentRateofChange + 0.2) * 6) * Difference)
			If(CoreTemperature > 99.8)
				CoreTemperature = 99.8
			EndIf
			Winter_Blanket_MSG.show()
			SendCustomEvent("OnChanged")
		Else
			SleepStopTime = Utility.GetCurrentGameTime()
			float Difference = (SleepStopTime - SleepStartTime) * 24
			Coretemperature = CoreTemperature + ((RecentRateofChange * 6) * Difference)
			If(CoreTemperature > 99.8)
				CoreTemperature = 99.8
			EndIf
			SendCustomEvent("OnChanged")
		EndIf
	EndEvent


	;Calculate Temp_Change
	;----------------------------------------------------------
	Event NuclearWinter:World:Climate.OnWeatherTransition(World:Climate akSender, var[] arguments)
		;Acquiring Target Temp_Change
		CalcTemperatureChange()
	EndEvent
	;-----------------------------------------------------------------

EndState
;I need to make a current temperature between the target so that it steadily changes when going indoor and outdoor
Function CalcTemperatureChange()
	WriteLine(Log, "==========================CalcTemperatureChange==========================")
	WriteLine(Log, "=========================================================================")
	If IsInWarmLocation
		If DetectInteriors.IsInFakeInterior
			If (Climate.AmbientTemp - TimeOfDayTempModifier) < 0
				TargetTemperature = (Climate.AmbientTemp - TimeOfDayTempModifier) * 0.3 + 65
				WriteLine(Log, "IsInWarmLocation and IsInFakeInterior: (AmbTemp(" + Climate.AmbientTemp + ") - TimeOfDayTempModifier(" +  TimeOfDayTempModifier + ")) * 0.3 + 65 = " + TargetTemperature)
			Else
				TargetTemperature = 65
				WriteLine(Log, "IsInWarmLocation and IsInFakeInterior: " + TargetTemperature)
			EndIf
			TargetWindSpeed = Climate.WindSpeed * 0.2
			WriteLine(Log, "TargetWindSpeed: WindSpeed(" + Climate.WindSpeed + ") * 0.2 = " + TargetWindSpeed)
		Else
			If (Climate.AmbientTemp - TimeOfDayTempModifier) < 0
				TargetTemperature = 68 - (Climate.AmbientTemp * 0.2)
				WriteLine(Log, "IsInWarmLocation: 68 - (AmbTemp(" + Climate.AmbientTemp + ") * 0.2) = " + TargetTemperature)
			Else
				TargetTemperature = 70
				WriteLine(Log, "TargetTemperature: 70")
			EndIf
			TargetWindSpeed = 0
			WriteLine(Log, "TargetWindSpeed: 0")
		EndIf
		;REMEMBER TO REMOVE THIS LATER
		;Debug.Notification("Entered a warm Location")
	ElseIf Player.IsInInterior()
		If (Climate.AmbientTemp - TimeOfDayTempModifier) < 0
			TargetTemperature = (Climate.AmbientTemp - TimeOfDayTempModifier) * 0.40 + 15
			WriteLine(Log, "IsInInterior: (AmbTemp(" + Climate.AmbientTemp + ") - TimeOfDayTempModifier(" +  TimeOfDayTempModifier + ")) * 0.4 + 15 = " + TargetTemperature)
		Else
			TargetTemperature = (Climate.AmbientTemp - TimeOfDayTempModifier) + 15
			WriteLine(Log, "IsInInterior: (AmbTemp(" + Climate.AmbientTemp + ") - TimeOfDayTempModifier(" +  TimeOfDayTempModifier + ")) + 15 = " + TargetTemperature)
		EndIf
		TargetWindSpeed = 0
		WriteLine(Log, "TargetWindSpeed: 0")
	ElseIf DetectInteriors.IsInFakeInterior
		If (Climate.AmbientTemp - TimeOfDayTempModifier) < 0
			TargetTemperature = (Climate.AmbientTemp - TimeOfDayTempModifier) * 0.5 + 5
			WriteLine(Log, "IsInFakeInterior: (AmbTemp(" + Climate.AmbientTemp + ") - TimeOfDayTempModifier(" +  TimeOfDayTempModifier + ")) * 0.5 + 5 = " + TargetTemperature)
		Else
			TargetTemperature = (Climate.AmbientTemp - TimeOfDayTempModifier) + 5
			WriteLine(Log, "IsInFakeInterior: (AmbTemp(" + Climate.AmbientTemp + ") - TimeOfDayTempModifier(" +  TimeOfDayTempModifier + ")) + 5 = " + TargetTemperature)
		EndIf
		TargetWindSpeed = Climate.WindSpeed * 0.2
		WriteLine(Log, "TargetWindSpeed: WindSpeed(" + Climate.WindSpeed + ") * 0.2 = " + TargetWindSpeed)
	ElseIf Climate.IsInSpecialArea
		WriteLine(Log, "IsInSpecialArea")
		TargetWindSpeed = Climate.WindSpeed * 0.5
		WriteLine(Log, "IsInSpecialArea: WindSpeed(" + Climate.WindSpeed + ") * 0.5 = " + TargetWindSpeed + " + 1")
		WindSpeed = TargetWindSpeed + 1
	Else
		TargetTemperature = (Climate.AmbientTemp - TimeOfDayTempModifier)
		WriteLine(Log, "IsOutside: AmbTemp(" + Climate.AmbientTemp + ") - TimeOfDayTempModifier(" +  TimeOfDayTempModifier + ") = " + TargetTemperature)
		TargetWindSpeed = Climate.WindSpeed
		WriteLine(Log, "TargetWindSpeed: " + Climate.WindSpeed)
	EndIf
	; If TargetWindSpeed != WindSpeed
		; StartTimer(1,WindTimer)
	; EndIf
	If TargetTemperature != Temperature
		StartTimer(1,TempTimer)
	EndIf
	WriteLine(Log, " ")
	WriteLine(Log, "Target Temperature/Wind Speed: "+ TargetTemperature + " | " + TargetWindSpeed)
	WriteLine(Log, " ")
	WriteLine(Log, " ")
EndFunction

Function CalcCoreTempChange()
	
	WriteLine(Log, "			===============CalcCoreTempChange===============")
	WriteLine(Log, "			================================================")	
	If HeatSource.IsInHeatSource == false
		float WindChill
		float RateofHeatChange ; Core Temperature Change over 900 sec
		If WindSpeed >= 3
			WindChill = (35.74+(0.6215 * Temperature) - (35.75 * pow(WindSpeed,0.16)) + (0.4275 * Temperature * pow(WindSpeed,0.16)))
			;WriteLine(Log,"			(35.74+(0.6215 * Temperature("+Temperature+")) - (35.75 * pow(WindSpeed("+WindSpeed+"),0.16)) + (0.4275 * Temperature("+Temperature+") * pow(WindSpeed("+WindSpeed+"),0.16))) = WindChill("+WindChill+")")
		Else
			WindChill = Temperature
			;WriteLine(Log,"			Temperature("+Temperature+") = WindChill("+WindChill+")")
		EndIf
		;If the exposure is above a certain windchill threshold start warming up instead of cooling
		If (Exposure >= 1.0) && (WindChill >= 60.0)
			RateofHeatChange = 0.25 * ((Exposure * 0.01) + 1) 
		ElseIf (Exposure >= 20.0) && (WindChill >= 55.0)
			RateofHeatChange = 0.25 * ((Exposure * 0.01) + 1) 
		ElseIf (Exposure >= 45.0) && (WindChill >= 45.0)
			RateofHeatChange = 0.25 * ((Exposure * 0.01) + 1) 
		ElseIf (Exposure >= 80.0) && (WindChill >= 25.0)
			RateofHeatChange = 0.20 * ((Exposure * 0.005) + 1) 
		ElseIf (Exposure == 100.0) && (WindChill >= 10.0)
			RateofHeatChange = 0.20
		ElseIf WindChill > 0
			If (Exposure == 0.0)
				RateofHeatChange = (((WindChill / Wetness) - 100.0) * (6/4)) * 0.004
				;WriteLine(Log,"			Note: If Exposure == 0, we artificially bump it to 4 to prevent extreme heat loss")
				;WriteLine(Log,"			(((WindChill("+WindChill+") / Wetness("+Wetness+")) - 100) (6/Exposure(4))) * 0.004 = RateofHeatChange("+RateofHeatChange+")")
			Else
				;Otherwise calculate the Rate of Change
				RateofHeatChange = (((WindChill / Wetness) - 100.0) * (6/(Exposure as float))) * 0.004
				;WriteLine(Log,"			(((WindChill("+WindChill+") / Wetness("+Wetness+")) - 100) (6/Exposure("+Exposure as float+"))) * 0.004 = RateofHeatChange("+RateofHeatChange+")")
				;Debug.Notification("RateofHeatChange:" + RateofHeatChange)
			EndIf
		Else
			If (Exposure == 0.0)
				RateofHeatChange = (((WindChill - 100.0) * (6/4)) * 0.004) * Wetness
				;WriteLine(Log,"			Note: If Exposure == 0, we artificially bump it to 4 to prevent extreme heat loss")
				;WriteLine(Log,"			(((WindChill("+WindChill+") - 100.0) * (6/Exposure(4))) * 0.004) * Wetness("+Wetness+") = RateofHeatChange("+RateofHeatChange+")")
			Else
				;Otherwise calculate the Rate of Change
				RateofHeatChange = (((WindChill - 100.0) * (6/(Exposure as float))) * 0.004) * Wetness
				;WriteLine(Log,"			(((WindChill("+WindChill+") - 100.0) * (6/Exposure("+Exposure as float+"))) * 0.004) * Wetness("+Wetness+") = RateofHeatChange("+RateofHeatChange+")")
				;Debug.Notification("RateofHeatChange:" + RateofHeatChange)
			EndIf
		EndIf
		WriteLine(Log,"			Alcohol: " + Player.HasMagicEffect(Winter_AlcoholWarmingEffect) + " | Food: " + Player.HasMagicEffect(Winter_FoodWarmingEffect))
		WriteLine(Log,"			WindChill:" + WindChill + " | Exposure: " + Exposure + " | Wetness: " + Wetness)
		WriteLine(Log,"			CoreTemp Rate of Change over 10 mins:" + (RateofHeatChange * 60.0))
		WriteLine(Log,"			CoreTemp Heat Change over 10 sec:" + RateofHeatChange)
		CoreTemperature = CoreTemperature + RateofHeatChange
		RecentRateofChange = RateofHeatChange
		;Debug.Notification("RateofHeatChange:" + RateofHeatChange)
		;Debug.Notification("WindChill:" + WindChill)
	Else
		Coretemperature = CoreTemperature + 1.5
		RecentRateofChange = 1.5
	EndIf
	If Player.HasMagicEffect(Winter_AlcoholWarmingEffect)
		CoreTemperature = CoreTemperature + 0.175
		RecentRateofChange += 0.175
	EndIf
	If Player.HasMagicEffect(Winter_HandWarmerEffect)
		CoreTemperature = CoreTemperature + 0.1
		RecentRateofChange += 0.1
	Endif
	If Player.HasMagicEffect(Winter_FoodWarmingEffect)
		CoreTemperature = CoreTemperature + 0.07
		RecentRateofChange += 0.07
	Endif
	If(CoreTemperature > 99.8)
		CoreTemperature = 99.8
	EndIf
	;Debug.Notification("Wetness:" + Wetness)
	WriteLine(Log,"			CoreTemperature:" + CoreTemperature)
	WriteLine(Log,"			================================================")	
	WriteLine(Log, "")	
EndFunction

float Function GetCurrentHourOfDay() 
 
	float Time = Utility.GetCurrentGameTime()
	Time -= Math.Floor(Time) ; Remove "previous in-game days passed" bit
	Time *= 24 ; Convert from fraction of a day to number of hours
	Return Time
 
EndFunction

;-----------------------------------------------------------------

; Find the effect of day/night time on the ambient temperature
Event OnTimerGameTime(int aiTimerID)
	
	If aiTimerID == TimeOfDayTimer
		TimeOfDayTempModifier = pow(GetCurrentHourOfDay() - 12, 2) / 9.5
		StartTimerGameTime(0.5,TimeOfDayTimer)
	EndIf
	
EndEvent

Event OnTimer(int aiTimerID)
	;WriteLine(Log, "PollTemp_Change()")

		If(aiTimerID == TempTimer)
			Winter_IsInWater_Spell.Cast(Player, Player)
			Winter_IsSwimming_Spell.Cast(Player, Player)
			If(Player.HasMagicEffect(Winter_IsSwimmingEffect))
				Wetness = 1.7
				StartTimer(30,WetTimer)
			ElseIf(Player.HasMagicEffect(Winter_IsInWaterEffect))
				Wetness = Wetness + 0.020
				If Wetness > 1.7
					Wetness = 1.7
				EndIf
				StartTimer(30,WetTimer)
			ElseIf(HeatSource.IsInHeatSource)
				Wetness = Wetness - 0.025
				If Wetness < 1.0
					Wetness = 1.0
				EndIf
			EndIf
			If Wetness < 1.5 && HeatSource.IsInHeatSource
				Player.DispelSpell(Winter_DrippingWater)
			EndIf
			
			If Player.IsInInterior() ; IF the player is indoors set the temperature immedietely.
				Temperature = TargetTemperature
			Else
				If TargetTemperature > Temperature ; Otherwise increase towards target temperature
					If (TargetTemperature - Temperature) <= 2.0
						Temperature = Temperature + 0.1
					ElseIf (TargetTemperature - Temperature) >= 30.0
						Temperature = Temperature + 3.25
					ElseIf (TargetTemperature - Temperature) >= 10.0
						Temperature = Temperature + 1.25
					ElseIf (TargetTemperature - Temperature) >= 5.0
						Temperature = Temperature + 0.5
					Else
						Temperature = Temperature + 0.25
					EndIf
				ElseIf TargetTemperature < Temperature	; Or decrease towards target temperature
					If (Temperature - TargetTemperature) >= 30.0
						Temperature = Temperature - 3.25
					ElseIf (Temperature - TargetTemperature) >= 10.0
						Temperature = Temperature - 1.25
					ElseIf (Temperature - TargetTemperature) >= 5.0
						Temperature = Temperature - 0.5
					ElseIf (Temperature - TargetTemperature) >= 2.0
						Temperature = Temperature - 0.25
					Else
						Temperature = Temperature - 0.1
					EndIf
				EndIf
			EndIf
			WriteLine(Log, "		Poll Temperature Change: " + Temperature)
			StartTimer(1,TempTimer)
			SendCustomEvent("OnChanged")
		EndIf
		
		If(aiTimerID == TempTimer)
			If Player.IsInInterior()
				WindSpeed = 0
			;ElseIf DetectInteriors.IsInFakeInterior
				;WindSpeed = TargetWindSpeed
			Else
				If TargetWindSpeed > WindSpeed
					If (TargetWindSpeed - WindSpeed) <= 2.0
						WindSpeed = WindSpeed + 0.1
					ElseIf (TargetWindSpeed - WindSpeed) >= 50.0
						WindSpeed = WindSpeed + 10.25
					ElseIf (TargetWindSpeed - WindSpeed) >= 30.0
						WindSpeed = WindSpeed + 3.25
					ElseIf (TargetWindSpeed - WindSpeed) >= 10.0
						WindSpeed = WindSpeed + 1.25
					ElseIf (TargetWindSpeed - WindSpeed) >= 5.0
						WindSpeed = WindSpeed + 0.5
					Else
						WindSpeed = WindSpeed + 0.25
					EndIf
				ElseIf TargetWindSpeed < WindSpeed
					If (WindSpeed - TargetWindSpeed) >= 50.0
						WindSpeed = WindSpeed - 10.25
					ElseIf (WindSpeed - TargetWindSpeed) >= 30.0
						WindSpeed = WindSpeed - 3.25
					ElseIf (WindSpeed - TargetWindSpeed) >= 10.0
						WindSpeed = WindSpeed - 1.25
					ElseIf (WindSpeed - TargetWindSpeed) >= 5.0
						WindSpeed = WindSpeed - 0.5
					ElseIf (WindSpeed - TargetWindSpeed) >= 2.0
						WindSpeed = WindSpeed - 0.25
					Else
						WindSpeed = WindSpeed - 0.1
					EndIf
				EndIf
				If WindSpeed < 0.0
					WindSpeed = 0.0
				Endif
			EndIf
			WriteLine(Log, "		Poll Wind Speed Change: "+ WindSpeed)
			;StartTimer(1,WindTimer)
		EndIf

		If(aiTimerID == CalcTimer)
			;WriteLine(Log, "Calculating Target")
			CalcTemperatureChange()
			CalcCoreTempChange()
			StartTimer(10,CalcTimer)
		EndIf
		
		If(aiTimerID == WetTimer) ;Slowly remove wetness over time
			Wetness = Wetness - (0.0075 * (WindSpeed/10)) ; Dry faster if there is wind
			If Wetness <= 1.0
				Wetness = 1.0
				CancelTimer(WetTimer)
			Else
				StartTimer(30, WetTimer)
			EndIf
		EndIf
		
		
		; If(aiTimerID == SFXTimer)
			; isPastThreshold = Threshold
			; WriteLine(Log, "Temp_Change: OnChanged | Timer | Threshold = "+Threshold)
			; SendCustomEvent("OnChanged")
			; StartTimer(16, SFXTimer)
		; EndIf
EndEvent

; Event NuclearWinter:Terminals:WorldThermodynamicMode.OnChanged(Terminals:WorldThermodynamicMode akSender, var[] arguments)
	; CalcTemperatureChange()
; EndEvent
;-----------------------------------------------------------------


;Empty Functions/Events
;---------------------------------------------

Event NuclearWinter:World:Climate.OnWeatherTransition(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:Gear:Equipment.OnChanged(Gear:Equipment akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:Gear:DetectInteriors.OnEnterInterior(Gear:DetectInteriors akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:Gear:DetectInteriors.OnExitInterior(Gear:DetectInteriors akSender, var[] arguments)
	{EMPTY}
EndEvent

Event OnPlayerSleepStart(float afSleepStartTime, float afDesiredSleepEndTime, ObjectReference akBed)
	{EMPTY}
EndEvent

Event OnPlayerSleepStop(bool abInterrupted, ObjectReference akBed)
	{EMPTY}
EndEvent

Event OnPlayerWaitStart(float afWaitStartTime, float afDesiredWaitEndTime)
	{EMPTY}
EndEvent
 
Event OnPlayerWaitStop(bool abInterrupted)
	{EMPTY}
EndEvent
; Properties
;---------------------------------------------

Group Context
	Gear:DetectInteriors Property DetectInteriors Auto Const Mandatory
	Gear:Equipment Property Equipment Auto Const Mandatory
	Gear:DetectRadiators Property DetectRadiators Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory
	World:HeatSource Property HeatSource Auto Const Mandatory
EndGroup

Group Properties
	GlobalVariable Property Winter_Exposure Auto
	GlobalVariable Property Winter_AmbientTemp Auto 
	GlobalVariable Property Winter_WindSpeed Auto 
	GlobalVariable Property Winter_CoreTemp Auto
	GlobalVariable Property Winter_Difficulty Auto
	GlobalVariable Property Winter_Wetness Auto
	GlobalVariable Property Winter_InWarmLocation Auto
	Spell Property Winter_IsInWater_Spell Auto
	Spell Property Winter_IsSwimming_Spell Auto
	Spell Property Winter_DrippingWater Auto
	MagicEffect Property Winter_IsInWaterEffect Auto
	MagicEffect Property Winter_IsSwimmingEffect Auto
	MagicEffect Property Winter_AlcoholWarmingEffect Auto
	MagicEffect Property Winter_FoodWarmingEffect Auto
	MagicEffect Property Winter_HandWarmerEffect Auto
	FormList Property Winter_WarmLocations Auto
	Form Property Winter_Blanket Auto
	Message Property Winter_Blanket_MSG Auto
	Keyword Property Winter_WarmLocation Auto
EndGroup


Group TemperatureChange

	; bool Property Threshold Hidden
		; bool Function Get()
			; return (Current.Target >= 17.0)
		; EndFunction
	; EndProperty
	
	int Property Exposure Hidden
		int Function Get()
			return Equipment.Exposure
		EndFunction
		Function Set(int value)
			Equipment.Exposure = value
		EndFunction
	EndProperty
	
	float Property CoreTemperature Hidden
		float Function Get()
			return Winter_CoreTemp.GetValue()
		EndFunction
		Function Set(float value)
			Winter_CoreTemp.SetValue(value)
		EndFunction
	EndProperty

	float Property Temperature Hidden
		float Function Get()
			return Winter_AmbientTemp.GetValue()
		EndFunction
		Function Set(float value)
			Winter_AmbientTemp.SetValue(value)
		EndFunction
	EndProperty
	
	float Property WindSpeed Hidden
		float Function Get()
			return Winter_WindSpeed.GetValue()
		EndFunction
		Function Set(float value)
			Winter_WindSpeed.SetValue(value)
		EndFunction
	EndProperty
	
	float Property Wetness Hidden
		float Function Get()
			return Winter_Wetness.GetValue()
		EndFunction
		Function Set(float value)
			Winter_Wetness.SetValue(value)
		EndFunction
	EndProperty
	
	bool Property IsInWarmLocation Hidden
		bool Function Get()
			If ((DetectInteriors.IsInFakeInterior || Player.IsInInterior()) && (Winter_WarmLocations.HasForm(Player.GetCurrentLocation() as Form) || Player.GetCurrentLocation().HasKeyword(Winter_WarmLocation) || DetectRadiators.IsInRadiator))
				Winter_InWarmLocation.SetValue(1.0)
				return True
			Else
				Winter_InWarmLocation.SetValue(0.0)
				return False
			EndIf
		EndFunction
	EndProperty
	
	Keyword Property ArmorTypePower Auto Const Mandatory

EndGroup
