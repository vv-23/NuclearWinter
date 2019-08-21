The root directory for this Papyrus import.
All first level child directories here are considered the beginning of a Papyrus namespace.

This project's default "import" uses the `PsAr82` identifier.
This project's default "namespace" uses the `NuclearWinter` identifier.

Add these files to this directory.

```
|   |           \---NuclearWinter
|   |               |   Context.psc
|   |               |   ContextActivation.psc
|   |               |   ContextSetup.psc
|   |               |   ContextWidget.psc
|   |               |   FrozenOnesLeveledActor.psc
|   |               |   HeatSourcePatches.psc
|   |               |   UtilityFunctions.psc
|   |               |
|   |               +---Core
|   |               |       Module.psc
|   |               |       Optional.psc
|   |               |       Required.psc
|   |               |
|   |               +---Gear
|   |               |       BeverageExpire.psc
|   |               |       BeverageHandling.psc
|   |               |       Database - Copy.psc
|   |               |       Database.psc
|   |               |       DetectExplosion.psc
|   |               |       DetectExplosionSmall.psc
|   |               |       DetectInteriors.psc
|   |               |       DetectRadiators.psc
|   |               |       Equipment.psc
|   |               |       ExposureValues.psc
|   |               |       Filter.psc
|   |               |       FilterReplace.psc
|   |               |       FoodExpire.psc
|   |               |       FoodHandling.psc
|   |               |       InsulationWidgetToggle.psc
|   |               |       LLInject.psc
|   |               |       Mask.psc
|   |               |       MaskBreathing.psc
|   |               |       MaskEquip.psc
|   |               |       MaskOverlay.psc
|   |               |       MaskWipe - No overlay stop.psc
|   |               |       MaskWipe - Old.psc
|   |               |       MaskWipe.psc
|   |               |       PlayerVoice.psc
|   |               |       ResetHelperMessages.psc
|   |               |
|   |               +---GUI
|   |               |       HUD.psc
|   |               |       HUDWidget.psc
|   |               |       InsulationWidget.psc
|   |               |       TemperatureWidget.psc
|   |               |
|   |               +---NPC
|   |               |       Cloak.psc
|   |               |       CloakApply.psc
|   |               |       CloakDamage.psc
|   |               |       CloakDistance.psc
|   |               |       CloakEquip - Copy.psc
|   |               |       CloakEquip.psc
|   |               |       CloakEquipChildren.psc
|   |               |       CloakShader.psc
|   |               |       FeralGhoulFrozenFXSCRIPT.psc
|   |               |
|   |               +---Player
|   |               |   |   Alcohol.psc
|   |               |   |   Amnesia.psc
|   |               |   |   Animation.psc
|   |               |   |   Breathing.psc
|   |               |   |   Camera.psc
|   |               |   |   Confusion.psc
|   |               |   |   CryoHit.psc
|   |               |   |   Freezing.psc
|   |               |   |   Frostbite.psc
|   |               |   |   Frostnip.psc
|   |               |   |   Gangrene.psc
|   |               |   |   MinorHypothermia.psc
|   |               |   |   ModerateHypothermia.psc
|   |               |   |   ParadoxicalUndressing.psc
|   |               |   |   Pneumonia.psc
|   |               |   |   SevereHypothermia.psc
|   |               |   |   Shivering.psc
|   |               |   |   Speech.psc
|   |               |   |   Sprinting.psc
|   |               |   |   SprintingSpell.psc
|   |               |   |   TerminalBurrowing.psc
|   |               |   |   TrenchFoot.psc
|   |               |   |
|   |               |   \---Conditions
|   |               |           IsFirstPerson.psc
|   |               |           IsPlayerInConversation.psc
|   |               |           IsSprinting.psc
|   |               |
|   |               +---Settlement
|   |               +---Terminals
|   |               |       ContextActivation.psc
|   |               |       DifficultyTerminal.psc
|   |               |       GearFilterAutoReplaceMode.psc
|   |               |       GearFilterInterval.psc
|   |               |       GearMaskBreathingPreset.psc
|   |               |       GearMaskFilterReplace.psc
|   |               |       GearMaskGlassOverlayPreset.psc
|   |               |       GearMaskGogglesOverlayPreset.psc
|   |               |       GearMaskLowFilterIMODPreset.psc
|   |               |       GearMaskOneEyeOverlayPreset.psc
|   |               |       GearMaskOverlayPreset.psc
|   |               |       GearMaskSackHoodOverlayPreset.psc
|   |               |       GearMaskWipeActivate.psc
|   |               |       GearOverlayAlways.psc
|   |               |       GeneralTerminal.psc
|   |               |       HUDOpacityOptions.psc
|   |               |       HUDScaleXOptions.psc
|   |               |       HUDScaleYOptions.psc
|   |               |       HUDTerminal.psc
|   |               |       HUDToggleOptions.psc
|   |               |       HUDXOptions.psc
|   |               |       HUDYOptions.psc
|   |               |       NPCCompanionMode.psc
|   |               |       NPCEquipMode.psc
|   |               |       ToggleFoodSystem.psc
|   |               |       ToggleGameplaySystem.psc
|   |               |       ToggleWeatherShaders.psc
|   |               |       WorldClimateMode.psc
|   |               |       WorldRadiationMode.psc
|   |               |       WorldWeatherWarningToggle.psc
|   |               |
|   |               +---Voice
|   |               |       PlayerVoice.psc
|   |               |
|   |               \---World
|   |                       AirFilter_Power.psc
|   |                       BreathEffect.psc
|   |                       CampingsiteCompatability.psc
|   |                       Climate.psc
|   |                       ClimateReader.psc
|   |                       DrippingWater.psc
|   |                       DrippringWater.psc
|   |                       FilteredAir.psc
|   |                       GeigerWidget.psc
|   |                       HeatSource.psc
|   |                       Radiation.psc
|   |                       RadiationOverlay.psc
|   |                       Radiation_old.psc
|   |                       Thermodynamics.psc
|   |                       WeatherDatabase.psc
|   |                       WeatherShader.psc
|   |                       WindSpeedEffect.psc
```# NuclearWinter
