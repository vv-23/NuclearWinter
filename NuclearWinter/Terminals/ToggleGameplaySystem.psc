ScriptName NuclearWinter:Terminals:ToggleGameplaySystem extends NuclearWinter:Core:Required

import Shared:Log
import NuclearWinter
import NuclearWinter:World

UserLog Log

float DisabledTemperature = 98.5

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent

Event OnEnable()
	MaxInsulation = Equipment.MaxInsulation
	Winter_GameplayToggle.SetValue(1.0)
	GameplaySystems = true
EndEvent


Event OnDisable()
	Winter_GameplayToggle.SetValue(0.0)
	GameplaySystems = false
EndEvent

; True = Turn On Gameplay Systems | False = Turn Off Gameplay Systems

Function SetGameplaySystem(bool value)
	GameplaySystems = value
	Equipment.SetEquipment(value)
	Freezing.SetFreezing(value)
	TemperatureWidget.SetHUDToggle(value)
	If value
		Winter_GameplayToggle.SetValue(1.0)
		Thermodynamics.Temperature = DisabledTemperature
		BeverageHandling.FoodToggle = true
		FoodHandling.FoodToggle = true
		WriteLine(Log, "Attempting to start the 'Food and Beverage System' context.")
	Else
		Winter_GameplayToggle.SetValue(0.0)
		DisabledTemperature = Thermodynamics.Temperature
		BeverageHandling.FoodToggle = false
		FoodHandling.FoodToggle = false
		WriteLine(Log, "Attempting to shutdown the 'Food and Beverage System'.")
	EndIf
EndFunction

Function SetMaxInsulation()
	Equipment.MaxInsulation = MaxInsulation
	Equipment.UpdateExposure()
EndFunction

Function SetInsulationSetting()
	Equipment.UniversalExposure = InsulationSetting as Bool
	Equipment.UpdateExposure()
	If InsulationSetting == 0
		MaxInsulation = 100
	Else
		MaxInsulation = 40
	EndIf
	Equipment.MaxInsulation = MaxInsulation
EndFunction

Int property MaxInsulation Auto
Int property InsulationSetting Auto
bool property GameplaySystems Auto
GlobalVariable Property Winter_GameplayToggle Auto
Gear:Equipment Property Equipment Auto Const
Player:Freezing Property Freezing Auto Const
GUI:TemperatureWidget Property TemperatureWidget Auto Const
Gear:FoodHandling Property FoodHandling Auto Const
Gear:BeverageHandling Property BeverageHandling Auto Const
World:Thermodynamics Property Thermodynamics Auto Const
