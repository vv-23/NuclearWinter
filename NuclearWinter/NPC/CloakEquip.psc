Scriptname NuclearWinter:NPC:CloakShader extends ActiveMagicEffect
{MGEF:NuclearWinter_CloakShaderEffect}
import NuclearWinter
import Shared:Log

UserLog Log
Actor Player
Actor NPC

float fTimer = 1.0
int iTimerID = 1
int BreathTimer = 2
float RadiusVeryLarge = 800.0
float RadiusLarge = 300.0
float RadiusMedium = 200.0
float RadiusSmall = 128.0

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
	If Search()
		StartTimer(1,BreathTimer)
	EndIf
	
EndEvent


; States
;---------------------------------------------

State AliveState

	Event OnBeginState(string asOldState)
		WriteLine(Log, "Entering the "+GetState()+" state from "+asOldState)
		StartTimer(3, TimerID)
	EndEvent


	Event OnTimer(int aiTimerID)
		WriteLine(Log, "OnTimer(aiTimerID="+aiTimerID+")")
		If SearchHeatSource()
	
		EndIf
		
		If aiTimerID == BreathTimer
			If(Thermodynamics.Temperature < 40.0)
				;WriteLine(Log, "Start Breath")
				Winter_Breath3rd_VFX.Play(NPC, 2.4)
				Winter_Breath3rd_VFX.Play(NPC, 2.2)
				Winter_Breath3rd_VFX.Play(NPC, 2.0)
				Winter_Breath3rd_VFX.Play(NPC, 1.8)
			EndIf
			StartTimer(4,BreathTimer)
		EndIf
	EndEvent


	Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		WriteLine(Log, "CloakShader: OnWeatherChanged")
		If SearchHeatSource()
		
		EndIf
	EndEvent

	Event NuclearWinter:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
		Utility.Wait(0.5)
		WriteLine(Log, "CloakShader: Player OnLocationChanged")
		If SearchHeatSource()

		EndIf
	EndEvent
	
	Event Actor.OnLocationChange(Actor akNPC, Location akOldLoc, Location akNewLoc)
		Utility.Wait(0.5)
		WriteLine(Log, "CloakShader: NPC OnLocationChange")
		If SearchHeatSource()
	
		EndIf
	EndEvent
	

	Event OnDying(Actor akKiller)
		WriteLine(Log, "OnDying(akKiller="+akKiller+")")
		GoToState(EmptyState)
	EndEvent


	Event OnEndState(string asNewState)
		WriteLine(Log, "Ending the "+GetState()+", new state "+asNewState)
		UnRegisterForRemoteEvent(NPC, "OnLocationChange")
		UnregisterForCustomEvent(Climate, "OnWeatherChanged")
		UnregisterForCustomEvent(Climate, "OnLocationChanged")
		CancelTimer(TimerID)
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


; Functions
;---------------------------------------------

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



; Properties
;---------------------------------------------

Group Context
	Terminals:NPCEquipMode Property NPCEquipMode Auto Const Mandatory
	World:Thermodynamics Property Thermodynamics Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory
EndGroup

Group Properties
	VisualEffect Property Winter_Breath3rd_VFX Auto
EndGroup


