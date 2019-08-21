Scriptname NuclearWinter:Gear:Filter extends NuclearWinter:Core:Optional
{QUST:NuclearWinter_Gear}
import NuclearWinter
import Shared:Log


UserLog Log

FilterItem Current
CustomEvent OnDegraded
CustomEvent OnConsumed
CustomEvent OnReplaced


int UpdateTimer = 0 const
int UpdateInterval = 1 const

int DegradeTimer = 1 const
int DegradeInterval = 20 const
int DegradeValue = 10 const

int ReplaceTimer = 2 const
int ReplaceInterval = 3 const

int ChargeDefault = 100 const

bool Success = true const
bool Failure = false const


Struct FilterItem
	int Charge = 0
EndStruct


; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Gear"
	AutoReplace = false
	Interval = DegradeInterval
	Current = new FilterItem
EndEvent


Event OnEnable()
	AddInventoryEventFilter(NuclearWinter_GearFilter)
	RegisterForCustomEvent(Mask, "OnChanged")
	RegisterForRemoteEvent(Player, "OnLocationChange")
	RegisterForMagicEffectApplyEvent(Player, akEffectFilter = DamageTypeRadiation)
	RegisterForCustomEvent(Climate, "OnWeatherChanged")
EndEvent


Event OnDisable()
	Current = new FilterItem
	RemoveAllInventoryEventFilters()
	UnregisterForCustomEvent(Mask, "OnChanged")
	UnregisterForRemoteEvent(Player, "OnLocationChange")
	UnregisterForAllMagicEffectApplyEvents(Player)
	UnregisterForCustomEvent(Climate, "OnWeatherChanged")
EndEvent



; Methods
;---------------------------------------------

State ActiveState
	Event OnBeginState(string asOldState)
		StartTimer(UpdateInterval, UpdateTimer)
	EndEvent


	Event NuclearWinter:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
		If(AutoReplace)
			If (Charge == 0 && Mask.IsGasMask && Quantity > 0)
				StartTimer(2, ReplaceTimer)
			EndIf
		EndIf
	EndEvent


	Event Actor.OnLocationChange(Actor akSender,Location akOldLoc, Location akNewLoc)
		StartTimer(UpdateInterval, UpdateTimer)
	EndEvent


	Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		If((Radiation.WeatherOnly && Climate.WeatherBad == true) || (Radiation.RadWeatherOnly && Climate.RadWeatherBad)	)
			WriteLine(Log, "Filter: OnWeatherChanged")
			StartTimer(UpdateInterval, UpdateTimer)
		EndIf
	EndEvent


	Event OnMagicEffectApply(ObjectReference akTarget, ObjectReference akCaster, MagicEffect akEffect)
		WriteLine(Log, "The '"+akEffect+"' magic effect has been applied to the '"+akTarget+"' reference.")
		RegisterForMagicEffectApplyEvent(Player, akEffectFilter = DamageTypeRadiation)
	EndEvent


	Event ObjectReference.OnItemAdded(ObjectReference akreference,Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
		Utility.wait(0.2)
		WriteLine(Log, "OnItemAdded "+akItemReference)
		If(AutoReplace)
			If (Charge == 0 && Mask.IsGasMask && Quantity > 0)
				StartTimer(1, ReplaceTimer)
			EndIf
		EndIf
	EndEvent


	Event OnTimer(int aiTimerID)
		If (aiTimerID == UpdateTimer)
			If (CanUse)
				StartTimer(Interval, DegradeTimer)
				WriteLine(Log, "UpdateTimer: Attempting to begin polling for degrade.")
			Else
				WriteLine(Log, "UpdateTimer: Cannot use filters at this time.")
			EndIf

		ElseIf (aiTimerID == DegradeTimer)
			If (Degrade(DegradeValue) == Success)
				StartTimer(Interval, DegradeTimer) ; polling
				WriteLine(Log, "DegradeTimer: Polling for degrade in '"+Interval+"' seconds.")
			Else
				WriteLine(Log, "DegradeTimer: The filter could not be degraded.")
			EndIf

		ElseIf (aiTimerID == ReplaceTimer)
			If (Replace() == Success)
				Player.RemoveItem(NuclearWinter_GearFilter, 1, true)
				Player.AddItem(NuclearWinter_GearFilterDirty, 1, true)
				WriteLine(Log, "ReplaceTimer: The filter has been automatically replaced. You have '"+Quantity+"' filters left.")
			Else
				WriteLine(Log, "ReplaceTimer: The filter could not be automatically replaced.")
			EndIf
		EndIf
	EndEvent


	Event OnEndState(string asNewState)
		CancelTimer(UpdateTimer)
		CancelTimer(DegradeTimer)
		CancelTimer(ReplaceTimer)
	EndEvent
EndState



Event Actor.OnLocationChange(Actor akSender,Location akOldLoc, Location akNewLoc)
	{EMPTY}
EndEvent

Event NuclearWinter:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
	{EMPTY}
EndEvent

Event ObjectReference.OnItemAdded(ObjectReference akreference,Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	{EMPTY}
EndEvent

Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent


; Functions
;---------------------------------------------

bool Function Degrade(int aiDegrade)
	If (IsReady)
		If (CanUse)
			If (Player.IsInInterior() == false && Player.HasMagicEffect(GasMask_AirFilter_SpellEffect) == false)
				aiDegrade = Math.Floor(Math.abs(aiDegrade))

				If (aiDegrade != 0)
					Current.Charge -= aiDegrade

					If (HasCharge)
						SendCustomEvent("OnDegraded")
						WriteLine(Log, "Degrade: The current filter has been degraded with '"+Current.Charge+"' charge remaining.")
						If (AutoReplace && Current.Charge == 10 && Quantity > 0)
							StartTimer(ReplaceInterval, ReplaceTimer)
							WriteLine(Log, "Degrade: The current filter will be automatically replaced in '"+ReplaceInterval+"' seconds.")
						EndIf
						return Success
					Else
						Current = new FilterItem ; empty
						Current.Charge = 0
						SendCustomEvent("OnConsumed")
						WriteLine(Log, "Degrade: The current filter has been consumed. You have '"+Quantity+"' filters left.")
						return Success
					EndIf
				Else
					WriteLine(Log, "Degrade: The degrade value must be larger than zero.")
					return Failure
				EndIf
			Else
				WriteLine(Log, "Degrade: Cannot use filters at this time.")
				return Failure
			EndIf
		Else
			WriteLine(Log, "Degrade: Cannot use filters at this time.")
			return Failure
		EndIf
	Else
		WriteLine(Log, "Degrade: The module is not ready.")
		return Failure
	EndIf
EndFunction


bool Function Replace()
	If (StateName == ActiveState)
		If (CanUse)
			Current = NewItem()
			WriteLine(Log, "Replace: The current filter has been replaced with a new one.")
			StartTimer(Interval, DegradeTimer)
			SendCustomEvent("OnReplaced")
			return Success
		Else
			WriteLine(Log, "Replace: Cannot use filters at this time.")
			return Failure
		EndIf
	Else
		WriteLine(Log, "Replace: Cannot call function outside of the '"+ActiveState+"' state.")
		return Failure
	EndIf
EndFunction


FilterItem Function NewItem()
	FilterItem filter = new FilterItem
	filter.Charge = ChargeDefault
	return filter
EndFunction


; Properties
;---------------------------------------------

Group Context
	Gear:Mask Property Mask Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory
	World:Radiation Property Radiation Auto Const Mandatory
EndGroup

Group Properties
	Potion Property NuclearWinter_GearFilter Auto Const Mandatory
	MiscObject Property NuclearWinter_GearFilterDirty Auto Const Mandatory
	Keyword Property DamageTypeRadiation Auto Const Mandatory
	MagicEffect Property GasMask_AirFilter_SpellEffect Auto Const Mandatory
EndGroup


Group Filters
	bool Property CanUse Hidden
		bool Function Get()
			If (IsReady)
				If((Radiation.WeatherOnly && Climate.WeatherBad) || (Radiation.WeatherOnly == false && Radiation.RadWeatherOnly == false) || (Radiation.RadWeatherOnly && Climate.RadWeatherbad))
					If (Player.IsInInterior() == false || Charge < 100)
						If (Mask.IsGasMask)
							If (Player.HasMagicEffect(GasMask_AirFilter_SpellEffect) == false)
								return true
							Else
								WriteLine(Log, "CanUse: Filters do not degrade while near filtration systems.")
								return false
							EndIf
						Else
							WriteLine(Log, "CanUse: Is not a gas mask.")
							return false
						EndIf
					Else
						WriteLine(Log, "CanUse: Filters do not degrade indoors or charge is already full.")
						return false
					EndIf
				Else
					WriteLine(Log, "CanUse: WeatherOnly - Cannot degrade while weather is clear.")
					return false
				EndIf
			Else
				WriteLine(Log, "CanUse: The module is not ready.")
				return false
			EndIf
		EndFunction
	EndProperty

	int Property Charge Hidden
		int Function Get()
			return Current.Charge
		EndFunction
	EndProperty

	bool Property HasCharge Hidden
		bool Function Get()
			return Current.Charge > 0
		EndFunction
	EndProperty
EndGroup


Group Inventory
	int Property Quantity Hidden
		int Function Get()
			return Player.GetItemCount(NuclearWinter_GearFilter)
		EndFunction
	EndProperty

	bool Property Available Hidden
		bool Function Get()
			return Quantity > 0
		EndFunction
	EndProperty
EndGroup


Group Settings
	bool Property AutoReplace Auto Hidden
	int Property Interval Auto Hidden
EndGroup
