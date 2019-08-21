Scriptname NuclearWinter:NPC:CloakShader extends ActiveMagicEffect
{MGEF:Winter_CloakEquipEffect}
import NuclearWinter
import Shared:Log

UserLog Log
Actor Player
Actor NPC

float fTimer = 3.0
;Timer IDs
int iTimerID = 0 const
int BreathTimer = 2 const
int WeatherTimerID = 1 const
;Heat Source Ranges
float RadiusVeryLarge = 800.0
float RadiusLarge = 300.0
float RadiusMedium = 200.0
float RadiusSmall = 128.0

EffectShader FXS
EffectShader NextShader
bool Effect

int TimerID = 0 const
string EmptyState = "" const
string AliveState = "AliveState" const

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_NPC"
EndEvent


Event OnEffectStart(Actor akTarget, Actor akCaster)
	WriteLine(Log, "OnEffectStart(akTarget="+akTarget+", akCaster="+akCaster+")")
	NPC = akTarget
	If NPC != None
		If NPC.Is3DLoaded()
			If NPC.IsDead() == false
				RegisterForCustomEvent(ToggleWeatherShaders, "OnToggle")
				RegisterForRemoteEvent(NPC, "OnLocationChange")
				RegisterForCustomEvent(Climate, "OnWeatherChanged")
				RegisterForCustomEvent(Climate, "OnLocationChanged")
				RegisterForCustomEvent(Thermodynamics, "OnChanged")
				Effect = false
				If Winter_BreathingRaceList.HasForm(NPC.GetRace())
					StartTimer(1,BreathTimer)
				EndIf
				GoToState("AliveState")
			Else
				CheckHeatSource()
				If NPC.IsInInterior() == false && IsInHeatSource == false && Thermodynamics.Temperature <= 15.0
					Winter_DeathShader.Play(NPC)
				EndIf	
			EndIf
		EndIf
	EndIf
EndEvent


; States
;---------------------------------------------

State AliveState

	Event OnBeginState(string asOldState)
		If NPC != None
			If NPC.Is3DLoaded()
				WriteLine(Log, "Entering the "+GetState()+" state from "+asOldState)
				CheckShader()
				StartTimer(fTimer, iTimerID)
				StartTimer(10.0, WeatherTimerID)
			EndIf
		EndIf
	EndEvent


	Event OnTimer(int aiTimerID)
		If NPC != None
			If NPC.Is3DLoaded()
				If (aiTimerID == iTimerID)
					CheckHeatSource()
					CheckTemperature()
					StartTimer(fTimer, iTimerID)
				EndIf
				
				If (aiTimerID == WeatherTimerID)
					CheckShader()
					StartTimer(10.0, WeatherTimerID)
				EndIf
				
				If aiTimerID == BreathTimer
					If(Thermodynamics.Temperature < 40.0)
						;WriteLine(Log, "Start Breath")
						Winter_Breath3rd_VFX.Play(NPC, 2.4)
						Winter_Breath3rd_VFX.Play(NPC, 2.2)
						Winter_Breath3rd_VFX.Play(NPC, 2.0)
						Winter_Breath3rd_VFX.Play(NPC, 1.8)
					EndIf
					If NPC.IsTalking()
						StartTimer(1,BreathTimer)
						;WriteLine(Log, "NPC is Talking")
					ElseIf NPC.IsSprinting()
						StartTimer(0.7,BreathTimer)
						;WriteLine(Log, "NPC is Sprinting")
					ElseIf NPC.IsInCombat() || NPC.IsRunning()
						StartTimer(2.5,BreathTimer)
						;WriteLine(Log, "NPC is In Combat or Running")
					Else
						StartTimer(4,BreathTimer)
						;WriteLine(Log, "NPC is Normal")
					EndIf
				EndIf
			EndIf
		Else
			GoToState("")
		EndIf	
	EndEvent


	Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		If NPC != None
			If NPC.Is3DLoaded()
				WriteLine(Log, "CloakShader: OnWeatherChanged")
				;Change FXS
				CheckShader()
			EndIf
		Else
			GoToState("")
		EndIf
	EndEvent

	Event NuclearWinter:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
		Utility.Wait(0.5)
		If NPC != None
			If NPC.Is3DLoaded()
				WriteLine(Log, "CloakShader: NPC OnLocationChanged")
				CheckHeatSource()
				CheckTemperature()
			EndIf
		Else
			GoToState("")
		EndIf
	EndEvent
	
	Event Actor.OnLocationChange(Actor akNPC, Location akOldLoc, Location akNewLoc)
		Utility.Wait(0.5)
		If NPC != None
			If NPC.Is3DLoaded()
				WriteLine(Log, "CloakShader: NPC OnLocationChange")
				CheckHeatSource()
				CheckTemperature()
			EndIf
		Else
			GoToState("")
		EndIf
	EndEvent
	

	Event OnDying(Actor akKiller)
		If NPC != None
			If NPC.Is3DLoaded()
				WriteLine(Log, "OnDying(akKiller="+akKiller+")")
				If NPC.IsInInterior() == false && IsInHeatSource == false && Thermodynamics.Temperature <= 20.0 && ShaderToggle == true
					Winter_DeathShader.Play(NPC)
				EndIf
			EndIf
		EndIf
		GoToState("")
	EndEvent


	Event OnEndState(string asNewState)
		WriteLine(Log, "Ending the "+GetState()+", new state "+asNewState)
		If NPC != None
			If NPC.Is3DLoaded()
				Stop()
			EndIf
		EndIf
		;WriteLine(Log, "Removed FXS for end of state.")
		UnRegisterForCustomEvent(ToggleWeatherShaders, "OnToggle")
		UnRegisterForRemoteEvent(NPC, "OnLocationChange")
		UnregisterForCustomEvent(Climate, "OnWeatherChanged")
		UnregisterForCustomEvent(Climate, "OnLocationChanged")
		UnRegisterForCustomEvent(Thermodynamics, "OnChanged")
		CancelTimer(TimerID)
		CancelTimer(WeatherTimerID)
		CancelTimer(BreathTimer)
	EndEvent
	
	Event NuclearWinter:Terminals:ToggleWeatherShaders.OnToggle(Terminals:ToggleWeatherShaders akSender, var[] arguments)
		Utility.Wait(2.0)
		If (ShaderToggle == true)
			ShaderToggle = false
			If NPC != None
				If NPC.Is3DLoaded()
					Stop()
				EndIf
			EndIf
		Else
			ShaderToggle = true
			CheckShader()
		EndIf
	EndEvent
	
	Event OnEffectFinish(Actor akTarget, Actor akCaster)
		If NPC != None
			If NPC.Is3DLoaded()
				Stop()
			EndIf
		EndIf
		UnRegisterForCustomEvent(ToggleWeatherShaders, "OnToggle")
		UnRegisterForRemoteEvent(NPC, "OnLocationChange")
		UnregisterForCustomEvent(Climate, "OnWeatherChanged")
		UnregisterForCustomEvent(Climate, "OnLocationChanged")
		UnRegisterForCustomEvent(Thermodynamics, "OnChanged")
		CancelTimer(TimerID)
		CancelTimer(WeatherTimerID)
		CancelTimer(BreathTimer)
	EndEvent
	
EndState

Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent

Event Actor.OnLocationChange(Actor akNPC, Location akOldLoc, Location akNewLoc)
	{EMPTY}
EndEvent

Event NuclearWinter:World:Thermodynamics.OnChanged(World:Thermodynamics akSender, var[] arguments)
	{EMPTY}
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	If NPC != None
		Stop()
	EndIf
	UnRegisterForCustomEvent(ToggleWeatherShaders, "OnToggle")
	UnRegisterForRemoteEvent(NPC, "OnLocationChange")
	UnregisterForCustomEvent(Climate, "OnWeatherChanged")
	UnregisterForCustomEvent(Climate, "OnLocationChanged")
	UnRegisterForCustomEvent(Thermodynamics, "OnChanged")
	CancelTimer(TimerID)
	CancelTimer(WeatherTimerID)
	CancelTimer(BreathTimer)
EndEvent

Event NuclearWinter:Terminals:ToggleWeatherShaders.OnToggle(Terminals:ToggleWeatherShaders akSender, var[] arguments)
	Utility.Wait(2.0)
	If (ShaderToggle == true)
		ShaderToggle = false
		If NPC != None
			Stop()
		EndIf
	Else
		ShaderToggle = true
	EndIf
EndEvent


; Functions
;---------------------------------------------

Function CheckShader()
	If (WeatherDatabase.GetEffectShader(Climate.CurrentWeather) != None)
		If (WeatherDatabase.GetEffectShader(Climate.CurrentWeather) != FXS)
			NextShader = WeatherDatabase.GetEffectShader(Climate.CurrentWeather)
			Stop()
			CheckTemperature()
			;WriteLine(Log, "New Effect: " + FXS)
		EndIf
	Else
		NextShader = Winter_EmptyShader
		;WriteLine(Log, "New Effect: None")
	EndIf
EndFunction

Function CheckHeatSource()
	If (SearchHeatSource())
		If(IsInHeatSource == false)
			IsInHeatSource = true
			WriteLine(Log, "NPC Entered Heat Source...")
		EndIf
	Else
		If(IsInHeatSource)
			IsInHeatSource = false
			WriteLine(Log, "NPC Exited Heat Source...")
		EndIf
	EndIf
EndFunction

Function CheckTemperature()
	If Thermodynamics.Temperature <= 32.0 && Effect == false && HeatSource.IsInHeatSource == false
		Start()
	ElseIf (Thermodynamics.Temperature > 32.0 || HeatSource.IsInHeatSource)
		Stop()
	EndIf
EndFunction

bool Function SearchHeatSource()
	ObjectReference[] FireList
	FireList = NPC.FindAllReferencesOfType(Winter_FireVeryLarge as Form, RadiusVeryLarge)
	If (FireList.length)
		return True
	EndIf
	FireList = NPC.FindAllReferencesOfType(Winter_FireLarge as Form, RadiusLarge)
	If (FireList.length)
		return True
	EndIf
	FireList = NPC.FindAllReferencesOfType(Winter_FireMedium as Form, RadiusMedium)
	If (FireList.length)
		return True
	EndIf
	FireList = NPC.FindAllReferencesOfType(Winter_FireSmall as Form, RadiusSmall)
	If (FireList.length)
		return True
	EndIf
	return false
EndFunction

Function Start()
	If (FXS != None)
		FXS.Play(NPC)
		Effect = true
		WriteLine(Log, "Start Effect: " + FXS)
	EndIf
EndFunction


Function Stop()
	If (FXS != None)
		FXS.Stop(NPC)
		Effect = false
		WriteLine(Log, "Stop Effect:" + FXS)
	EndIf
	FXS = NextShader
EndFunction



; Properties
;---------------------------------------------

Group Context
	World:Climate Property Climate Auto Const Mandatory
	World:Thermodynamics Property Thermodynamics Auto Const Mandatory
	World:WeatherDatabase Property WeatherDatabase Auto Const Mandatory
	World:HeatSource Property HeatSource Auto Const Mandatory
	Terminals:ToggleWeatherShaders Property ToggleWeatherShaders Auto Const Mandatory 
EndGroup

Group Properties
	bool Property ShaderToggle Auto
	bool Property IsInHeatSource Auto
	VisualEffect Property Winter_Breath3rd_VFX Auto
	EffectShader Property Winter_EmptyShader Auto
	EffectShader Property Winter_DeathShader Auto Const
	FormList Property Winter_FireVeryLarge Auto Const
	FormList Property Winter_FireLarge Auto Const
	FormList Property Winter_FireMedium Auto Const
	FormList Property Winter_FireSmall Auto Const
	FormList Property Winter_BreathingRaceList Auto Const
EndGroup



