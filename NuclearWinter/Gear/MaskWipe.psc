Scriptname NuclearWinter:Gear:MaskWipe extends NuclearWinter:Core:Optional
{MGEF:NuclearWinter_Gear}
import NuclearWinter
import NuclearWinter:Player:Animation
import Shared:Log

UserLog Log


int RainStartTimer = 0
int RainLoopTimer = 1
int RainEndTimer = 2
int DustStartTimer = 3
int SnowStartTimer = 4
int SnowEndTimer = 5

int randomDust = 0
bool interior = false
bool FirstWipe = true
bool DustAlreadyOn = false
bool DustOverlayOn = false
bool SnowOverlayOn = false
Data Current

; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Mask Wipe"
EndEvent


Event OnEnable()
	WriteLine(Log, "Mask Wipe Intialized.")
	MaskWipeActivate = True
	RainToggle = True
	DirtToggle = True
	BloodToggle = True
	DustToggle = True
	SnowToggle = True
	RegisterForCustomEvent(GearMaskWipeActivate, "OnChanged")
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForCustomEvent(Mask, "OnChanged")
	RegisterForCustomEvent(Climate, "OnWeatherChanged")
	RegisterForCustomEvent(Climate, "OnLocationChanged")
	RegisterForCustomEvent(DetectInteriors, "OnEnterInterior")
	RegisterForCustomEvent(DetectInteriors, "OnExitInterior")
	Current = new Data
EndEvent


Event OnDisable()
	WriteLine(Log, "Mask Wipe Disabled.")
	MaskWipeActivate = false
	RainToggle = false
	DirtToggle = false
	BloodToggle = false
	DustToggle = false
	SnowToggle = false
	UnRegisterForCustomEvent(GearMaskWipeActivate, "OnChanged")
	UnregisterForRemoteEvent(Player, "OnItemEquipped")
	UnregisterForCustomEvent(Mask, "OnChanged")
	UnRegisterForCustomEvent(Climate, "OnWeatherChanged")
	UnRegisterForCustomEvent(Climate, "OnLocationChanged")
	UnRegisterForCustomEvent(DetectInteriors, "OnEnterInterior")
	UnRegisterForCustomEvent(DetectInteriors, "OnExitInterior")
	EndAll(false,true,true,true,true)
EndEvent

Struct Data
	bool RainEndLoop = false
	bool Raining = false
	bool Snowing = false
	bool Duststorm = false
	int SnowStage = 0
	int BloodStage = 0
	int BloodSmearStage = 0
	int MudStage = 0
EndStruct


; Methods
;---------------------------------------------

State ActiveState
	Event NuclearWinter:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
		;int iCount = Player.GetItemCount(NuclearWinter_GearWipe)
		;Player.RemoveItem(NuclearWinter_GearWipe, iCount, abSilent = true)

		If (Mask.IsGasMask)
			WriteLine(Log, "Gas Mask Equipped...")
			Player.AddItem(NuclearWinter_GearWipe, 1, abSilent = true)
			WriteLine(Log, "Added the mask wipe item.")
			Utility.Wait(1.3)
			If Current.RainEndLoop
				StartTimer(0.1, RainEndTimer)
			EndIf
			If Current.BloodStage > 0
				BloodUpdate(false)
			EndIf
			If Current.MudStage > 0
				MudUpdate(false)
			EndIf
			If DustOverlayOn
				DustUpdate()
			EndIf
			If SnowOverlayOn
				SnowUpdate(false)
			EndIf
			Evaluate()
		;Add conditions here as you add more visual effects | This removes them if they are currently active and a mask is removed
		Else
			WriteLine(Log, "Gas Mask Removed...")
			Utility.Wait(0.5)
			If(Current.RainEndLoop)
				NuclearWinter_GearWipeVFX_RainEndLoop.Stop(Player)
			EndIf
			WriteLine(Log, "No Mask, End VFX | Climate: " + Climate.Classification + " | isRaining: " + Current.Raining + " | BloodStage: " + Current.BloodStage)
			EndAll(false,true,true,true,true)
			If Current.Raining
				Current.Raining = false
			EndIf
			If Current.Snowing
				Current.Snowing = false
			EndIf
			If Current.Duststorm
				Current.Duststorm = false
			EndIf
		EndIf
	EndEvent
	
	Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		WriteLine(Log, "Weather Changed...")
		Evaluate()
	EndEvent
	
	Event NuclearWinter:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
		WriteLine(Log, "Changed Location...")
		Utility.wait(2.0)
		If Player.IsInInterior() && Mask.IsGasMask
			MaskOverlay.Remove()
			MaskOverlay.Apply()
			BloodUpdate(false)
			MudUpdate(false)
			If DustOverlayOn
				DustUpdate()
			Endif
			If SnowOverlayOn
				SnowUpdate(false)
			EndIf
			interior = true
			WriteLine(Log, "Entered Interior...")
			Evaluate()
		Else
			If interior && Mask.IsGasMask
				MaskOverlay.Remove()
				MaskOverlay.Apply()
				If DustOverlayOn
					DustUpdate()
				EndIf
				If SnowOverlayOn
					SnowUpdate(false)
				EndIf
				interior = false
			EndIf
			BloodUpdate(false)
			MudUpdate(false)
			Evaluate()
		EndIf	
	EndEvent
	
	Event NuclearWinter:Gear:DetectInteriors.OnEnterInterior(Gear:DetectInteriors akSender, var[] arguments)
		Evaluate()
	EndEvent
	
	Event NuclearWinter:Gear:DetectInteriors.OnExitInterior(Gear:DetectInteriors akSender, var[] arguments)
		Evaluate()
	EndEvent
	
	Event OnTimer(int aiTimerID)
		; Start Rain
		If aiTimerID == RainStartTimer
			Current.Raining = true
			Current.RainEndLoop = false
			MaskOverlay.Remove()
			CancelTimer(RainLoopTimer)
			CancelTimer(RainEndTimer)
			NuclearWinter_GearWipeVFX_RainEndLoop.Stop(Player)
			NuclearWinter_GearWipeVFX_RainEnd.Stop(Player)
			NuclearWinter_GearWipeVFX_RainLoop.Stop(Player)
			NuclearWinter_GearWipeVFX_RainStart.Stop(Player)
			NuclearWinter_GearWipeVFX_RainStart.Play(Player,RainDuration_Start)
			MaskOverlay.Apply()
			WriteLine(Log, "Start RainVFX.")
			StartTimer(RainDuration_Start - Rain_Start_Overlap, RainLoopTimer)
		EndIf
		; Loop Rain
		If aiTimerID == RainLoopTimer
			NuclearWinter_GearWipeVFX_RainLoop.Stop(Player)
			NuclearWinter_GearWipeVFX_RainLoop.Play(Player,RainDuration_Loop)
			WriteLine(Log, "Loop RainVFX.")
			StartTimer(RainDuration_Loop - Rain_Loop_Overlap, RainLoopTimer)
		EndIf
		; After Ending, Play static Rain End Loop
		If aiTimerID == RainEndTimer
			If Mask.IsGasMask
				MaskOverlay.Remove()
				NuclearWinter_GearWipeVFX_RainEndLoop.Stop(Player)
				NuclearWinter_GearWipeVFX_RainEndLoop.Play(Player)
				Current.RainEndLoop = true
				MaskOverlay.Apply()
				WriteLine(Log, "EndLoop RainVFX.")
				StartTimer(60.0, RainEndTimer)
			EndIf
		EndIf
		
		If aiTimerID == DustStartTimer
			If Mask.IsGasMask
				DustUpdate()
			EndIf
		EndIf
		
		If aiTimerID == SnowStartTimer
			If Mask.IsGasMask
				CancelTimer(SnowEndTimer)
				SnowUpdate(true)
			EndIf
		EndIf
		
		If aiTimerID == SnowEndTimer
			If Mask.IsGasMask
				CancelTimer(SnowStartTimer)
				SnowMelt()
			EndIf
		EndIf
	EndEvent

	Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
		If (akBaseObject == NuclearWinter_GearWipe)
			If (Utility.IsInMenuMode())
				NuclearWinter_GearExitPipboyMessage.Show()
			EndIf
			If (Player.GetItemCount(NuclearWinter_GearWipe) == 0)
				Player.AddItem(NuclearWinter_GearWipe, 1, abSilent = true)
				WriteLine(Log, "Refunding the mask wipe item.")
			EndIf
			GasMask_Gear_MaskWipeFade.Apply(1.0)
			If(Mask.FormID == 0x001184C1)
				If(IsFirstPerson)
					IdlePlay(Player, MaskWipeIdleFP, Log)
				Else
					IdlePlay(Player, MaskWipeIdleTP, Log)
				EndIf
			ElseIf(Mask.FormID == 0x00007A77)
				If(IsFirstPerson)
					IdlePlay(Player, M1A211_1stPUseMaskWipeOnSelf, Log)
				Else
					IdlePlay(Player, M1A211_3rdPUseMaskWipeOnSelf, Log)
				EndIf
			ElseIf(Mask.FormID == 0x000787D8)
				If(IsFirstPerson)
					IdlePlay(Player, SingleVisor_1stPUseMaskWipeOnSelf, Log)
				Else
					IdlePlay(Player, SingleVisor_3rdPUseMaskWipeOnSelf, Log)
				EndIf
			Else
				If(IsFirstPerson)
					IdlePlay(Player, MaskWipeIdleFP, Log)
				Else
					IdlePlay(Player, MaskWipeIdleTP, Log)
				EndIf
			EndIf
			NuclearWinter_GearWipeSFX.Play(Player)
			If Current.BloodStage > 0
				EndBlood(true)
			EndIf
			If Current.MudStage > 0
				EndMud(true)
			EndIf
			If DustOverlayOn
				EndDust(true)
				DustOverlayOn = false
				DustAlreadyOn = false
			EndIf
			If Current.SnowStage > 0
				EndSnow(true)
				SnowOverlayOn = false
			EndIf
			;Check Rain
			WriteLine(Log, "HandRefrac VFX.")
			If (Climate.Classification == 2.0 && Current.Raining)
				EndRain(false, true)
			ElseIf (Climate.Classification == 3.0)
				;Place Holder
			EndIf
			If(Current.RainEndLoop)
				CancelTimer(RainEndTimer)
				NuclearWinter_GearWipeVFX_RainEndLoop.Stop(Player)
				Current.RainEndLoop = false
			EndIf
		EndIf	
		
	EndEvent
EndState

Event NuclearWinter:Terminals:GearMaskWipeActivate.OnChanged(Terminals:GearMaskWipeActivate akSender, var[] arguments)
		If MaskWipeActivate
			GoToState("ActiveState")
			Evaluate()
		Else
			EndAll(false,true,true,false,false)
			GoToState("")
		EndIf
EndEvent

Event NuclearWinter:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
	{EMPTY}
EndEvent

Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	{EMPTY}
EndEvent

Event NuclearWinter:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
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
;Function
;---------------------------------------------

Function Evaluate()
	WriteLine(Log, "Evaluating...")
	; Do I have a mask on? If not, remove all
	If Mask.IsGasMask
		; Am I indoors? If I am, prevent environmental fx such as rain and maintain already present effects (except rain).
		If Player.IsInInterior() == false
			; Am I in a fake interior in the Commonwealth? If I am then treat it as an interior.
			If(DetectInteriors.IsInFakeInterior == false)
				WriteLine(Log, "Evaluation | Climate:" + Climate.Classification + " | Raining? " + Current.Raining)
				
				; It started snowing, begin VFX
				If (Climate.TypeClass == 0 && Current.Snowing == false)
					WriteLine(Log, "Started Snowing, start VFX")
					Current.Snowing = true
					CancelTimer(SnowEndTimer)
					StartTimer(Snow_Restart, SnowStartTimer)
				ElseIf (Climate.TypeClass != 0 && Current.Snowing)
					WriteLine(Log, "Stopped Snowing, ending VFX")
					Current.Snowing = false
					CancelTimer(SnowStartTimer)
					StartTimer(Snow_Restart, SnowEndTimer)
				EndIf
				
				
				; It started a dust storm, begin VFX
				If (Climate.TypeClass == 1 && Current.Duststorm == false)
					WriteLine(Log, "Started a Dust Storm, start VFX")
					Current.Duststorm = true
					StartTimer(Dust_Restart, DustStartTimer)
				EndIf
				
				; It started raining, begin VFX
				If RainToggle
					If (Climate.Classification == 2.0 && Current.Raining == false && Current.Snowing == false)
						WriteLine(Log, "Started Raining, start VFX")
						Current.Raining = true
						StartTimer(Rain_Restart, RainStartTimer)
					; It is no longer raining, ending VFX
					ElseIf(Climate.Classification != 2.0 && Current.Raining)
						WriteLine(Log, "Stopped Raining, ending VFX")
						Current.Raining = false
						EndRain(true, false)
					EndIf
				EndIf
			
			Else
					WriteLine(Log, "Fake Interior, End VFX | Climate: " + Climate.Classification + " | isRaining: " + Current.Raining + " | BloodStage: " + Current.BloodStage)
					EndAll(false,false,false,false,false)
				If Current.Raining
					StartTimer(0.1, RainEndTimer)
					Current.Raining = false
				EndIf
				If Current.Snowing
					StartTimer(0.1, SnowEndTimer)
					Current.Snowing = false
				EndIf
			EndIf
		Else
				WriteLine(Log, "Interior, End VFX | Climate: " + Climate.Classification + " | isRaining: " + Current.Raining + " | BloodStage: " + Current.BloodStage)
				EndAll(false,false,false,false,false)
			If Current.Raining
				StartTimer(0.1, RainEndTimer)
				Current.Raining = false
			EndIf
			If Current.Snowing
				StartTimer(RainDuration_End - 0.5, SnowEndTimer)
				NuclearWinter_GearWipeVFX_RainEnd.Play(Player,RainDuration_End)
				Current.Snowing = false
			EndIf
			If Current.Duststorm
				;StartTimer(0.1, DustEndTimer)
				Current.Duststorm = false
			EndIf
		EndIf
	Else
		WriteLine(Log, "No Mask, End VFX | Climate: " + Climate.Classification + " | isRaining: " + Current.Raining + " | BloodStage: " + Current.BloodStage)
		EndAll(false,true,true,true,true)
		If Current.Raining
			Current.Raining = false
		EndIf
		If Current.Snowing
			Current.Snowing = false
		EndIf
		If Current.Duststorm
			Current.Duststorm = false
		EndIf
	EndIf
	
EndFunction

;Npc has been hit within range.
Function BloodUpdate(bool update)
	If BloodToggle && MaskWipeActivate
		If Mask.IsGasMask
			If update
				If Current.BloodStage == 0
					Current.BloodStage += 1
					NuclearWinter_GearWipeVFX_BloodStageOne.Play(Player)
				ElseIf Current.BloodStage == 1
					Current.BloodStage += 1
					NuclearWinter_GearWipeVFX_BloodStageTwo.Play(Player)
					Utility.wait(0.5)
					NuclearWinter_GearWipeVFX_BloodStageOne.Stop(Player)
				ElseIf Current.BloodStage == 2
					Current.BloodStage += 1
					NuclearWinter_GearWipeVFX_BloodStageThree.Play(Player)
					Utility.wait(0.5)
					NuclearWinter_GearWipeVFX_BloodStageTwo.Stop(Player)
				ElseIf Current.BloodStage == 3
					Current.BloodStage += 1
					NuclearWinter_GearWipeVFX_BloodStageFour.Play(Player)
					Utility.wait(0.5)
					NuclearWinter_GearWipeVFX_BloodStageThree.Stop(Player)
				ElseIf Current.BloodStage == 4
					Current.BloodStage += 1
					NuclearWinter_GearWipeVFX_BloodStageFive.Play(Player)
					Utility.wait(0.5)
					NuclearWinter_GearWipeVFX_BloodStageFour.Stop(Player)
				Else
				EndIf
			Else
				If Current.BloodStage == 1
					NuclearWinter_GearWipeVFX_BloodStageOne.Play(Player)
				ElseIf Current.BloodStage == 2
					NuclearWinter_GearWipeVFX_BloodStageTwo.Play(Player)
				ElseIf Current.BloodStage == 3
					NuclearWinter_GearWipeVFX_BloodStageThree.Play(Player)
				ElseIf Current.BloodStage == 4
					NuclearWinter_GearWipeVFX_BloodStageFour.Play(Player)
				ElseIf Current.BloodStage == 5
					NuclearWinter_GearWipeVFX_BloodStageFive.Play(Player)
				EndIf
			EndIf
			WriteLine(Log, "Adding Blood VFX | Stage: " + Current.BloodStage)
		EndIf
	EndIf
EndFunction

;In range of an explosion.
Function MudUpdate(bool update)
	If DirtToggle && MaskWipeActivate
		If Mask.IsGasMask
			If update
				If Current.MudStage == 0
					Current.MudStage += 1
					NuclearWinter_GearWipeVFX_MudStageOne.Play(Player)
				ElseIf Current.MudStage == 1
					Current.MudStage += 1
					NuclearWinter_GearWipeVFX_MudStageTwo.Play(Player)
					Utility.wait(0.5)
					NuclearWinter_GearWipeVFX_MudStageOne.Stop(Player)
				ElseIf Current.MudStage == 2
					Current.MudStage += 1
					NuclearWinter_GearWipeVFX_MudStageThree.Play(Player)
					Utility.wait(0.5)
					NuclearWinter_GearWipeVFX_MudStageTwo.Stop(Player)
				ElseIf Current.MudStage == 3
					Current.MudStage += 1
					NuclearWinter_GearWipeVFX_MudStageFour.Play(Player)
					Utility.wait(0.5)
					NuclearWinter_GearWipeVFX_MudStageThree.Stop(Player)
				Else
				EndIf
			Else
					If Current.MudStage == 1
						NuclearWinter_GearWipeVFX_MudStageOne.Play(Player)
					ElseIf Current.MudStage == 2
						NuclearWinter_GearWipeVFX_MudStageTwo.Play(Player)
					ElseIf Current.MudStage == 3
						NuclearWinter_GearWipeVFX_MudStageThree.Play(Player)
					ElseIf Current.MudStage == 4
						NuclearWinter_GearWipeVFX_MudStageFour.Play(Player)
					EndIf
			EndIf
			WriteLine(Log, "Adding Mud VFX | Stage: " + Current.MudStage)
		EndIf
	EndIf
EndFunction

Function DustUpdate()
	If DustToggle && MaskWipeActivate
		If Mask.IsGasMask
			If DustOverlayOn == false
				randomDust = Utility.RandomInt(0, 2)
				If randomDust == 0
					NuclearWinter_GearWipeVFX_Dust.Play(Player)
				ElseIf randomDust == 1
					NuclearWinter_GearWipeVFX_Dust2.Play(Player)
				ElseIf randomDust == 2
					NuclearWinter_GearWipeVFX_Dust3.Play(Player)
				EndIf
				DustAlreadyOn = true
				DustOverlayOn = true
				WriteLine(Log, "Adding Dust VFX | DustStorm: " + Current.DustStorm)
			ElseIf DustOverlayOn && DustAlreadyOn == false
				DustAlreadyOn = true
				If randomDust == 0
					NuclearWinter_GearWipeVFX_Dust.Play(Player)
				ElseIf randomDust == 1
					NuclearWinter_GearWipeVFX_Dust2.Play(Player)
				ElseIf randomDust == 2
					NuclearWinter_GearWipeVFX_Dust3.Play(Player)
				EndIf
				WriteLine(Log, "Reapplying Dust VFX | DustStorm: " + Current.DustStorm)
			EndIf
		EndIf
	EndIf
EndFunction


Function SnowUpdate(bool Update)
	If SnowToggle && MaskWipeActivate
		If Mask.IsGasMask
			If Update
				SnowOverlayOn = true
				If Current.SnowStage == 0 
					NuclearWinter_GearWipeVFX_Snow.Play(Player)
					StartTimer(Snow_Restart, SnowStartTimer)
					Current.SnowStage += 1
				ElseIf Current.SnowStage == 1
					NuclearWinter_GearWipeVFX_Snow2.Play(Player)
					Utility.wait(0.5)
					NuclearWinter_GearWipeVFX_Snow.Stop(Player)
					StartTimer(Snow_Restart, SnowStartTimer)
					Current.SnowStage += 1
				ElseIf Current.SnowStage == 2
					NuclearWinter_GearWipeVFX_Snow3.Play(Player)
					Utility.wait(0.5)
					NuclearWinter_GearWipeVFX_Snow2.Stop(Player)
					StartTimer(Snow_Restart, SnowStartTimer)
					Current.SnowStage += 1
				ElseIf Current.SnowStage == 3
					NuclearWinter_GearWipeVFX_Snow4.Play(Player)
					Utility.wait(0.5)
					NuclearWinter_GearWipeVFX_Snow3.Stop(Player)
					StartTimer(Snow_Restart, SnowStartTimer)
					Current.SnowStage += 1
				ElseIf Current.SnowStage == 4
					NuclearWinter_GearWipeVFX_Snow5.Play(Player)
					Utility.wait(0.5)
					NuclearWinter_GearWipeVFX_Snow4.Stop(Player)
				EndIf
				WriteLine(Log, "Adding Snow VFX | SnowStage: " + Current.SnowStage + " | SnowStorm: " + Current.Snowing)
			ElseIf SnowOverlayOn
				If Current.SnowStage == 1
					NuclearWinter_GearWipeVFX_Snow.Play(Player)
				ElseIf Current.SnowStage == 2
					NuclearWinter_GearWipeVFX_Snow2.Play(Player)
				ElseIf Current.SnowStage == 3
					NuclearWinter_GearWipeVFX_Snow3.Play(Player)
				ElseIf Current.SnowStage == 4
					NuclearWinter_GearWipeVFX_Snow4.Play(Player)
				ElseIf Current.SnowStage == 5
					NuclearWinter_GearWipeVFX_Snow5.Play(Player)
				EndIf
				WriteLine(Log, "Reapplying Snow VFX | SnowStage: " + Current.SnowStage + " | SnowStorm: " + Current.Snowing)
			EndIf
		EndIf
	EndIf
EndFunction

Function SnowMelt()
	If Current.SnowStage > 0
		If Current.SnowStage == 1
			NuclearWinter_GearWipeVFX_Snow.Stop(Player)
		ElseIf Current.SnowStage == 2
			NuclearWinter_GearWipeVFX_Snow.Play(Player)
			Utility.wait(0.5)
			NuclearWinter_GearWipeVFX_Snow2.Stop(Player)
			StartTimer(Snow_Restart, SnowEndTimer)
			Current.SnowStage -= 1
		ElseIf Current.SnowStage == 3
			NuclearWinter_GearWipeVFX_Snow2.Play(Player)
			Utility.wait(0.5)
			NuclearWinter_GearWipeVFX_Snow3.Stop(Player)
			StartTimer(Snow_Restart, SnowEndTimer)
			Current.SnowStage -= 1
		ElseIf Current.SnowStage == 4
			NuclearWinter_GearWipeVFX_Snow3.Play(Player)
			Utility.wait(0.5)
			NuclearWinter_GearWipeVFX_Snow4.Stop(Player)
			StartTimer(Snow_Restart, SnowEndTimer)
			Current.SnowStage -= 1
		ElseIf Current.SnowStage == 5
			NuclearWinter_GearWipeVFX_Snow4.Play(Player)
			Utility.wait(0.5)
			NuclearWinter_GearWipeVFX_Snow5.Stop(Player)
			StartTimer(Snow_Restart, SnowEndTimer)
			Current.SnowStage -= 1
		EndIf
		WriteLine(Log, "Snow Melting: Current Stage = " + Current.SnowStage + " | Old Stage = " + (Current.SnowStage + 1))
	EndIf
EndFunction

Function EndRain(bool PlayRainEnd, bool DoEval)
	WriteLine(Log, "EndRain: Ending Rain." + PlayRainEnd)
	Current.Raining = false
	CancelTimer(RainLoopTimer)
	CancelTimer(RainStartTimer)
	CancelTimer(RainEndTimer)
	Utility.wait(0.5)
	NuclearWinter_GearWipeVFX_RainLoop.Stop(Player)
	Utility.wait(0.5)
	NuclearWinter_GearWipeVFX_RainStart.Stop(Player)
	Utility.wait(0.5)
	NuclearWinter_GearWipeVFX_RainEnd.Stop(Player)
	If PlayRainEnd
		NuclearWinter_GearWipeVFX_RainEnd.Play(Player,RainDuration_End)
		WriteLine(Log, "End RainVFX.")
		StartTimer(RainDuration_End - Rain_End_Overlap, RainEndTimer)
	EndIf
	If DoEval
		Utility.Wait(2.0)
		Evaluate()
	EndIf
EndFunction

Function EndBlood(bool restart)
	If Current.BloodStage > 0
		WriteLine(Log, "Removing Blood VFX")
		If Current.BloodStage == 1
			Utility.wait(0.15)
			NuclearWinter_GearWipeVFX_BloodStageOne.Stop(Player)
			NuclearWinter_GearWipeVFX_BloodFadeHStageOne.Play(Player, 0.5)
			If FirstWipe
				NuclearWinter_GearWipeVFX_BloodSmearStageOne.Play(Player)
				Current.BloodSmearStage = 1
			Endif
		ElseIf Current.BloodStage == 2
			Utility.wait(0.15)
			NuclearWinter_GearWipeVFX_BloodStageTwo.Stop(Player)
			NuclearWinter_GearWipeVFX_BloodFadeHStageTwo.Play(Player, 0.5)
			If FirstWipe
				NuclearWinter_GearWipeVFX_BloodSmearStageTwo.Play(Player)
				Current.BloodSmearStage = 2
			EndIf
		ElseIf Current.BloodStage == 3
			Utility.wait(0.15)
			NuclearWinter_GearWipeVFX_BloodStageThree.Stop(Player)
			NuclearWinter_GearWipeVFX_BloodFadeHStageThree.Play(Player, 0.5)
			If FirstWipe
				NuclearWinter_GearWipeVFX_BloodSmearStageThree.Play(Player)
				Current.BloodSmearStage = 3
			EndIf
		ElseIf Current.BloodStage == 4
			Utility.wait(0.15)
			NuclearWinter_GearWipeVFX_BloodStageFour.Stop(Player)
			NuclearWinter_GearWipeVFX_BloodFadeHStageFour.Play(Player, 0.5)
			If FirstWipe
				NuclearWinter_GearWipeVFX_BloodSmearStageFour.Play(Player)
				Current.BloodSmearStage = 4
			EndIf
		ElseIf Current.BloodStage == 5
			Utility.wait(0.15)
			NuclearWinter_GearWipeVFX_BloodStageFive.Stop(Player)
			NuclearWinter_GearWipeVFX_BloodFadeHStageFive.Play(Player, 0.5)
			If FirstWipe
				NuclearWinter_GearWipeVFX_BloodSmearStageFive.Play(Player)
				Current.BloodSmearStage = 5
			EndIf
		EndIf
		If restart
			Current.BloodStage = 0
		EndIf
	EndIf
	SmearBlood(false)
	If Current.BloodSmearStage > 0
		FirstWipe = false
	EndIf
EndFunction

Function SmearBlood(bool ignore)
	If FirstWipe == false || ignore
		If Current.BloodSmearStage == 1
			NuclearWinter_GearWipeVFX_BloodSmearStageOne.Stop(Player)
		ElseIf Current.BloodSmearStage == 2
			NuclearWinter_GearWipeVFX_BloodSmearStageTwo.Stop(Player)
		ElseIf Current.BloodSmearStage == 3
			NuclearWinter_GearWipeVFX_BloodSmearStageThree.Stop(Player)
		ElseIf Current.BloodSmearStage == 4
			NuclearWinter_GearWipeVFX_BloodSmearStageFour.Stop(Player)
		ElseIf Current.BloodSmearStage == 5
			NuclearWinter_GearWipeVFX_BloodSmearStageFive.Stop(Player)
		EndIf
		FirstWipe = true
		Current.BloodSmearStage = 0
	EndIf
EndFunction

Function EndMud(bool restart)
	If Current.MudStage > 0
		WriteLine(Log, "Removing Mud VFX")
		If Current.MudStage == 1
			NuclearWinter_GearWipeVFX_MudStageOne.Stop(Player)
		ElseIf Current.MudStage == 2
			NuclearWinter_GearWipeVFX_MudStageTwo.Stop(Player)
		ElseIf Current.MudStage == 3
			NuclearWinter_GearWipeVFX_MudStageThree.Stop(Player)
		ElseIf Current.MudStage == 4
			NuclearWinter_GearWipeVFX_MudStageFour.Stop(Player)
		EndIf
		If restart
			Current.MudStage = 0
		EndIf
	EndIf
EndFunction

Function EndDust(bool DoEval)
	If DustAlreadyOn
		If randomDust == 0
			NuclearWinter_GearWipeVFX_Dust.Stop(Player)
		ElseIf randomDust == 1
			NuclearWinter_GearWipeVFX_Dust2.Stop(Player)
		ElseIf randomDust == 2
			NuclearWinter_GearWipeVFX_Dust3.Stop(Player)
		EndIf
		Current.DustStorm = false
		DustAlreadyOn = false
	EndIf
	If DoEval
		Evaluate()
	EndIf
EndFunction

Function EndSnow(bool DoEval)
	If Current.SnowStage > 0
	WriteLine(Log, "Removing Snow VFX")
		If Current.SnowStage == 1
			NuclearWinter_GearWipeVFX_Snow.Stop(Player)
		ElseIf Current.SnowStage == 2
			NuclearWinter_GearWipeVFX_Snow2.Stop(Player)
		ElseIf Current.SnowStage == 3
			NuclearWinter_GearWipeVFX_Snow3.Stop(Player)
		ElseIf Current.SnowStage == 4
			NuclearWinter_GearWipeVFX_Snow4.Stop(Player)
		ElseIf Current.SnowStage == 5
			NuclearWinter_GearWipeVFX_Snow5.Stop(Player)
		EndIf
		CancelTimer(SnowEndTimer)
		CancelTimer(SnowStartTimer)
		Current.SnowStage = 0
		Current.Snowing = false
	EndIf
	If DoEval
		Current.SnowStage = 0
		Evaluate()
	EndIf
EndFunction

Function EndAll(bool DoRainEval, bool RemoveBlood, bool RemoveDirt, bool RemoveDust, bool RemoveSnow)
	WriteLine(Log, "EndAll VFX...")
	If(Current.Raining)
		;Do we want to re-evaluate Rain?
		If DoRainEval
			WriteLine(Log, "Then re-evaluate Rain VFX")
			EndRain(false, true)
		Else
			EndRain(false, false)
		EndIf
	EndIf
	;Do we want to re-evaluate Snow?
	If RemoveSnow
		WriteLine(Log, "Then re-evaluate Snow VFX")
		EndSnow(false)
	EndIf
	;Do we want to re-evaluate Dust?
	If RemoveDust
		WriteLine(Log, "Then re-evaluate Dust VFX")
		EndDust(false)
	EndIf
	;Do we want to remove blood?
	If RemoveBlood
		EndBlood(false)
		SmearBlood(true)
	EndIf
	If RemoveDirt
		EndMud(false)
	EndIf
EndFunction

; Properties
;---------------------------------------------

Group Context
	Terminals:GearMaskWipeActivate Property GearMaskWipeActivate Auto Const Mandatory
	Gear:DetectInteriors Property DetectInteriors Auto Const Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:MaskOverlay Property MaskOverlay Auto Const Mandatory
	World:WeatherDatabase Property WeatherDatabase Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory 
EndGroup

Group Properties
	ImageSpaceModifier property GasMask_Gear_MaskWipeFade Auto Const Mandatory
	bool property BloodToggle Auto
	bool property DirtToggle Auto
	bool property RainToggle Auto
	bool property DustToggle Auto
	bool property SnowToggle Auto
	bool property MaskWipeActivate Auto
	Potion Property NuclearWinter_GearWipe Auto Const Mandatory
	Sound Property NuclearWinter_GearWipeSFX Auto Const Mandatory
	Message Property NuclearWinter_GearExitPipboyMessage Auto Const Mandatory
	Idle property MaskWipeIdleFP Auto Const Mandatory
	Idle property MaskWipeIdleTP Auto Const Mandatory
	Idle property M1A211_1stPUseMaskWipeOnSelf Auto Const Mandatory
	Idle property M1A211_3rdPUseMaskWipeOnSelf Auto Const Mandatory
	Idle property SingleVisor_1stPUseMaskWipeOnSelf Auto Const Mandatory
	Idle property SingleVisor_3rdPUseMaskWipeOnSelf Auto Const Mandatory
	VisualEffect property HandRefraction Auto Const Mandatory
	VisualEffect property EyebotSmokingE Auto Const Mandatory
	Int property HandRefractionDuration Auto Const Mandatory
	{Duration of Hand Refraction Effect}
EndGroup

Group VFX
	;Rain -------------------------------
	VisualEffect property NuclearWinter_GearWipeVFX_RainStart Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_RainLoop Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_RainEnd Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_RainEndLoop Auto Const Mandatory
	;Blood ------------------------------
	VisualEffect property NuclearWinter_GearWipeVFX_BloodFadeHStageOne Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_BloodFadeHStageTwo Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_BloodFadeHStageThree Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_BloodFadeHStageFour Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_BloodFadeHStageFive Auto Const Mandatory
	
	VisualEffect property NuclearWinter_GearWipeVFX_BloodSmearStageOne Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_BloodSmearStageTwo Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_BloodSmearStageThree Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_BloodSmearStageFour Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_BloodSmearStageFive Auto Const Mandatory
	
	VisualEffect property NuclearWinter_GearWipeVFX_BloodStageOne Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_BloodStageTwo Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_BloodStageThree Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_BloodStageFour Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_BloodStageFive Auto Const Mandatory
	;Mud ---------------------------------
	VisualEffect property NuclearWinter_GearWipeVFX_MudStageOne Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_MudStageTwo Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_MudStageThree Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_MudStageFour Auto Const Mandatory
	;Dust ---------------------------------
	VisualEffect property NuclearWinter_GearWipeVFX_Dust Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_Dust2 Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_Dust3 Auto Const Mandatory
	;Snow ---------------------------------
	VisualEffect property NuclearWinter_GearWipeVFX_Snow Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_Snow2 Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_Snow3 Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_Snow4 Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_Snow5 Auto Const Mandatory
	
	Int property RainDuration_Start Auto
	{Duration of Rain start.}
	Int property RainDuration_Loop Auto
	{Duration of the Rain loop.}
	Int property RainDuration_End Auto
	{Duration after Rain Weather for Rain effect to end.}
	Int property Rain_Start_Overlap Auto
	{RainDuration_Start - Overlap}
	Int property Rain_Loop_Overlap Auto
	{RainDuration_Loop - Overlap}
	Int property Rain_End_Overlap Auto
	{RainDuration_End - Overlap}
	Int property Rain_Restart Auto
	{Duration before rain effect restarts after being wiped away}
	Int property Dust_Restart Auto
	{Duration before dust effect restarts after being wiped away}
	Int property Snow_Restart Auto
	{Duration before snow effect restarts after being wiped away}
EndGroup


Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Player.GetAnimationVariableBool("IsFirstPerson")
		EndFunction
	EndProperty
EndGroup

Bool Property Raining Hidden
		Bool Function Get()
			return Current.Raining
		EndFunction
		Function Set(Bool value)
			Current.Raining = value
		EndFunction
EndProperty

Bool Property EndRainLoop Hidden
		Bool Function Get()
			return Current.RainEndLoop
		EndFunction
		Function Set(Bool value)
			Current.RainEndLoop = value
		EndFunction
EndProperty

