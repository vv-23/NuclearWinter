Scriptname NuclearWinter:World:Radiation extends NuclearWinter:Core:Optional
{QUST:NuclearWinter_World}
import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log
Data Current
CustomEvent OnChanged
CustomEvent OnThreshold

bool first = true

float UpdateInterval
float In_target_radiation
float Out_target_radiation
float InWeatherPerc
float OutWeatherPerc

int UpdateTimer = 0 const
int CalcTimer = 1 const
int SFXTimer = 2 const

var[] params

Struct Data
	float Exposure = 0.0
	float Target = 0.0
EndStruct

; Events
;==========================================================================================

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Radiation"
	In_Target_Radiation = 0
	Out_Target_Radiation = 0
	isPastThreshold = false
	Current = new Data
EndEvent


Event OnEnable()
	AddInventoryEventFilter(NuclearWinter_GearFilter)
	RegisterForCustomEvent(Mask, "OnChanged")
	RegisterForCustomEvent(Filter, "OnConsumed")
	RegisterForCustomEvent(Climate, "OnWeatherTransition")
	RegisterForCustomEvent(Climate, "OnWeatherChanged")
	RegisterForCustomEvent(Climate, "OnLocationChanged")
	RegisterForRemoteEvent(Player, "OnItemAdded")
	RegisterForCustomEvent(WorldRadiationMode, "OnChanged")
EndEvent


Event OnDisable()
	RemoveInventoryEventFilter(NuclearWinter_GearFilter)
	UnregisterForCustomEvent(Mask, "OnChanged")
	UnregisterForCustomEvent(Filter, "OnConsumed")
	UnregisterForCustomEvent(Climate, "OnWeatherTransition")
	UnregisterForCustomEvent(Climate, "OnWeatherChanged")
	UnregisterForCustomEvent(Climate, "OnLocationChanged")
	UnregisterForRemoteEvent(Player, "OnItemAdded")
	UnregisterForCustomEvent(WorldRadiationMode, "OnChanged")
EndEvent

; Radiation Events/Functions
;==========================================================================================
State ActiveState
	Event OnBeginState(string asOldState)
		WriteLine(Log, "Beginning the ActiveState from the '"+asOldState+"'.")
		Current = new Data
	EndEvent

	;Events for Starting Radiation
	;----------------------------------------------------------

	Event NuclearWinter:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
		WriteLine(Log, "Radiation: OnLocationChanged")
		If (Mask.IsGasMask == false || (Filter.Available == false || Filter.HasCharge == false) && Mask.IsPowerArmor == false)
			WriteLine(Log, "The player has no equipment for gas masks.")
			CheckRadiation()
		EndIf
	EndEvent

	Event NuclearWinter:Gear:Filter.OnConsumed(Gear:Filter akSender, var[] arguments)
		WriteLine(Log, "Radiation: OnConsumed")
		If (Filter.Available == false || Filter.HasCharge == false)
			CheckRadiation()
		EndIf
	EndEvent

	Event NuclearWinter:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
		WriteLine(Log, "Radiation: Mask.OnChanged")
		Utility.wait(0.2)
		If (Mask.IsGasMask == false && Mask.IsPowerArmor == false)
			CheckRadiation()
		EndIf
	EndEvent

	Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		WriteLine(Log, "Radiation: OnWeatherChanged")

		If ((akSender.WeatherBad && WeatherOnly) || (akSender.RadWeatherBad && RadWeatherOnly)) ; || (WeatherOnly == false)
			WriteLine(Log, "The current weather is bad.")
			CheckRadiation()
		ElseIf(WeatherOnly || RadWeatherOnly)
			WriteLine(Log, "The current weather is not bad.")
			Dispel_Rad()
		EndIf
	EndEvent


	;Check for Start Radiation
	;----------------------------------------------------------
	Function CheckRadiation()
		WriteLine(Log, "CheckRadiation()")
		If (IsRadioactive)
			If ((Climate.WeatherBad) && (WeatherOnly)) || (WeatherOnly == false && RadWeatherOnly == false) || (Climate.RadWeatherBad && RadWeatherOnly)
				WriteLine(Log, "CheckRadiation() waiting for ")
				GoToState("RadiationONState")
			Else
				WriteLine(Log, "CheckRadiation() WeatherOnly conditions prevent player from casting the spell")
			EndIf
		Else
			WriteLine(Log, "CheckRadiation() failed the conditions for radiation")
		EndIf
	EndFunction
	;----------------------------------------------------------

EndState

State RadiationONState

	Event OnBeginState(string asOldState)
		WriteLine(Log, "Beginning the RadiationOnState from the '"+asOldState+"'.")
		Current = new Data
		StartTimer(2,CalcTimer)
	EndEvent

	;Events for Removing Radiation
	;----------------------------------------------------------

	Event NuclearWinter:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
		WriteLine(Log, "Handling Climate.OnLocationChanged")
		If (Player.IsInInterior())
			WriteLine(Log, "Player Inside, removing Radiation")
			Dispel_Rad()
		EndIf
	EndEvent


	Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		WriteLine(Log, "Radiation: OnWeatherChanged")
		If (akSender.WeatherBad == false && WeatherOnly || akSender.RadWeatherBad == false && RadWeatherOnly)
			WriteLine(Log, "The current weather is not bad.")
			Dispel_Rad()
		ElseIf((akSender.WeatherBad && WeatherOnly) || (WeatherOnly == false && RadWeatherOnly == false) || (akSender.RadWeatherBad && RadWeatherOnly))
			CalcRadiation()
		EndIf
	EndEvent


	Event NuclearWinter:Gear:Filter.OnReplaced(Gear:Filter akSender,var[] arguments)
		If (Filter.Charge > 0 && Mask.IsGasMask)
			Dispel_Rad()
		EndIf
	EndEvent

	Event NuclearWinter:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
		Utility.wait(0.2)
		If(Mask.IsGasMask && Filter.Charge > 0)
			Dispel_Rad()
		EndIf
	EndEvent

	Event ObjectReference.OnItemAdded(ObjectReference akreference,Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
		Utility.wait(0.2)
		WriteLine(Log, "OnItemAdded "+akItemReference)
		If (Filter.Charge > 0 && Mask.IsGasMask)
			Dispel_Rad()
		EndIf
	EndEvent


	;Calculate Radiation
	;----------------------------------------------------------
	Event NuclearWinter:World:Climate.OnWeatherTransition(World:Climate akSender, var[] arguments)
		;Acquiring Target Radiation
		CalcRadiation()
	EndEvent
	;-----------------------------------------------------------------

EndState

Function CalcRadiation()
	If(IsRadioactive)
		In_target_radiation = 0
		Out_target_radiation = 0
		InWeatherPerc = Climate.Transition
		OutWeatherPerc = 1 - InWeatherPerc

		If ((Climate.WeatherBad) && (WeatherOnly)) || (WeatherOnly == false && RadWeatherOnly == false) || (Climate.RadWeatherBad && RadWeatherOnly)
			In_target_radiation = InWeatherPerc*InWeatherPerc*GetMultiplier(Climate.Classification, true)
			WriteLine(Log, "Radiation: In Target "+ In_target_radiation)
		EndIf

		Current.Target = in_target_radiation

		If Mask.IsBandana
			Current.Target = (Current.Target * 0.25)
		EndIf

		If first == true
			WriteLine(Log, "Update Timer First...")
			StartTimer(0, UpdateTimer)
			first = false
		EndIf
		WriteLine(Log, "Update Timer...")
		StartTimer(2, UpdateTimer)
		
		;Initiates SFX loop
		If(Threshold && isPastThreshold == false)
				isPastThreshold = true
				SendCustomEvent("OnChanged", params)
				WriteLine(Log, "Radiation: OnChanged | Threshold = "+Threshold)
				StartTimer(16, SFXTimer)
		EndIf
	Else
		Dispel_Rad()
	EndIf

EndFunction

;Apply Radiation
;-----------------------------------------------------------------
Event OnTimer(int aiTimerID)
	;WriteLine(Log, "PollRadiation()")

		if(aiTimerID == UpdateTimer)
			WriteLine(Log, "Radiation: Exposure "+Current.Exposure+ " | Target "+Current.Target)
			;Accelerate
			if ((Current.Exposure+2) < Current.Target) && (Current.Exposure > 6)
				 Current.Exposure += 2
				 NuclearWinter_RadiationWasteland_2X.Cast(Player, Player)
			EndIf

			;Increment
			if (Current.Exposure < Current.Target)
				NuclearWinter_RadiationWasteland.Cast(Player, Player)

				Current.Exposure += 1
				UpdateInterval = 0.2; accelerate radiation until we match target radiation
				
				if (Current.Target<3);if target is low, lets slow the pulses down
					UpdateInterval = Utility.RandomInt(1, 6)
				EndIf

				StartTimer(UpdateInterval,UpdateTimer)
			Else
				UpdateInterval = 2; recheck in 2 seconds
				StartTimer(UpdateInterval,UpdateTimer)
				Current.Exposure = 0
			EndIf
			
			;Initiates SFX loop
		EndIf

		If(aiTimerID == CalcTimer)
			WriteLine(Log, "Calculating Target")

			CalcRadiation()
			StartTimer(10,CalcTimer)
		EndIf
		
		If(aiTimerID == SFXTimer)
			isPastThreshold = Threshold
			WriteLine(Log, "Radiation: OnChanged | Timer | Threshold = "+Threshold)
			SendCustomEvent("OnChanged")
			StartTimer(16, SFXTimer)
		EndIf
EndEvent

Event NuclearWinter:Terminals:WorldRadiationMode.OnChanged(Terminals:WorldRadiationMode akSender, var[] arguments)
	CalcRadiation()
EndEvent
;-----------------------------------------------------------------


Function Dispel_Rad()
	WriteLine(Log, "Dispel_Rad()")
	CancelTimer(SFXTimer)
	CancelTimer(UpdateTimer)
	CancelTimer(CalcTimer)
	Player.DispelSpell(NuclearWinter_RadiationWasteland)
	first = true
	isPastThreshold = false
	WriteLine(Log, "Radiation: OnChanged | Dispel_Rad | Threshold = "+Threshold)
	SendCustomEvent("OnChanged")
	GoToState("ActiveState")
EndFunction

int Function GetMultiplier(int aiWeatherClass, bool abInWeather = true)
	If (aiWeatherClass == Climate.WeatherClassNone)
		return 0
	ElseIf (aiWeatherClass == Climate.WeatherClassPleasant)
		If (abInWeather)
			return InMultiplierA
		EndIf
	ElseIf (aiWeatherClass == Climate.WeatherClassCloudy)
		If (abInWeather)
			return InMultiplierB
		EndIf
	ElseIf (aiWeatherClass == Climate.WeatherClassRainy)
		If (abInWeather)
			return InMultiplierC
		EndIf
	ElseIf (aiWeatherClass == Climate.WeatherClassSnow)
		If (abInWeather)
			return InMultiplierD
		EndIf
	Else
		; unknown weather class
		return 0
	EndIf
EndFunction

;Empty Functions/Events
;---------------------------------------------

Event NuclearWinter:World:Climate.OnWeatherTransition(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent

Function CheckRadiation()
	{EMPTY}
EndFunction

Event NuclearWinter:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:Gear:Filter.OnConsumed(Gear:Filter akSender,var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:Gear:Filter.OnReplaced(Gear:Filter akSender,var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
	{EMPTY}
EndEvent

Event ObjectReference.OnItemAdded(ObjectReference akReference,Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	{EMPTY}
EndEvent

Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent


; Properties
;---------------------------------------------

Group Context
	Terminals:WorldRadiationMode Property WorldRadiationMode Auto Const Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:Filter Property Filter Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory
EndGroup

Group Properties
	Faction Property ChildrenOfAtomFaction Auto Const Mandatory
	Potion Property NuclearWinter_GearFilter Auto Const Mandatory
	Spell Property NuclearWinter_RadiationWasteland Auto Const Mandatory
	Spell Property NuclearWinter_RadiationWasteland_2X Auto Const Mandatory
	MagicEffect Property GasMask_AirFilter_SpellEffect Auto Const Mandatory
EndGroup


Group Radiation
	float Property Exposure Hidden
		float Function Get()
			return Current.Exposure
		EndFunction
		Function Set(float value)
			Current.Exposure += value
		EndFunction
	EndProperty

	bool Property Threshold Hidden
		bool Function Get()
			return (Current.Target >= 17.0)
		EndFunction
	EndProperty
	
	bool Property isPastThreshold Auto Hidden
		
	bool Property IsRadioactive Hidden
		bool Function Get()
			If (Player.IsInInterior() == false && Player.IsInFaction(ChildrenOfAtomFaction) == false && Player.WornHasKeyword(ArmorTypePower) == false && Player.HasMagicEffect(GasMask_AirFilter_SpellEffect) == false && ( Mask.IsGasMask == false || ((Filter.Available == false && Filter.HasCharge == false) || Filter.HasCharge == false) ) )
				return true
			Else
				return false
			EndIf
		EndFunction
	EndProperty

	int Property InMultiplierA = 7 AutoReadOnly
	int Property InMultiplierB = 17 AutoReadOnly
	int Property InMultiplierC = 29 AutoReadOnly
	int Property InMultiplierD = 61 AutoReadOnly
	
	Keyword Property ArmorTypePower Auto Const Mandatory

EndGroup


Group Settings
	bool Property WeatherOnly = false Auto Hidden
	bool Property RadWeatherOnly = false Auto Hidden
	bool property NoRadiation = false Auto Hidden
EndGroup
