Scriptname NuclearWinter:Player:Speech extends NuclearWinter:Core:Required
import NuclearWinter:Context
import Shared:Log

UserLog Log

CustomEvent OnDialogue
float ChangeVolume_Breathing
float ChangeVolume_Sprinting
float ChangeVolume_Choking
float ChangeVolume_Coughing
int Breathing_SoundInstance
int Sprinting_SoundInstance
int Choking_SoundInstance
int Coughing_SoundInstance
int SoundInstance
int ResetCounter
bool GoToNoSound

; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Speech"
	Breathing_SoundInstance = -1
	Sprinting_SoundInstance = -1
	Choking_SoundInstance = -1
	Coughing_SoundInstance = -1
	ResetCounter = 0
EndEvent


Event OnEnable()
	Player.AddSpell(GasMask_Condition_IsPlayerInConversation, false)
	GasMask_Condition_IsPlayerInConversation.Cast(none, Player)
	WriteLine(Log, "Added the '"+GasMask_Condition_IsPlayerInConversation+"' spell.")
	GoToNoSound = false
EndEvent


Event OnDisable()
	AudioStop(SoundInstance, Log)
	Player.DispelSpell(GasMask_Condition_IsPlayerInConversation)
	Player.RemoveSpell(GasMask_Condition_IsPlayerInConversation)
	WriteLine(Log, "Removed the '"+GasMask_Condition_IsPlayerInConversation+"' spell.")
EndEvent

Event OnTimer(int aiTimerID)

	If(ChangeVolume_Breathing == 1.0)
	
		If(CurrentVolume_Sprinting > ChangeVolume_Sprinting) ; Reduce Sprinting to 0.0
				CurrentVolume_Sprinting -= 0.2
				Sound.SetInstanceVolume(Sprinting_SoundInstance, CurrentVolume_Sprinting)
		EndIf
		
		If(CurrentVolume_Choking > ChangeVolume_Choking) ; Reduce Choking to 0.0
				CurrentVolume_Choking -= 0.2
				Sound.SetInstanceVolume(Choking_SoundInstance, CurrentVolume_Choking)
		EndIf
		
		If(CurrentVolume_Coughing > ChangeVolume_Coughing) ; Reduce Coughing to 0.0
				CurrentVolume_Coughing -= 0.2
				Sound.SetInstanceVolume(Coughing_SoundInstance, CurrentVolume_Coughing)
		EndIf
			
		If(CurrentVolume_Choking == ChangeVolume_Choking && CurrentVolume_Sprinting == ChangeVolume_Sprinting && CurrentVolume_Coughing == ChangeVolume_Coughing) ; Check Choking, Sprinting 0.0
			If(CurrentVolume_Breathing < ChangeVolume_Breathing) ; Increase breathing to 1.0
					CurrentVolume_Breathing += 0.2
					Sound.SetInstanceVolume(Breathing_SoundInstance, CurrentVolume_Breathing)
			EndIf
		EndIf
	
	
	ElseIf(ChangeVolume_Sprinting == 1.0)
	
		If(CurrentVolume_Breathing > ChangeVolume_Breathing) ; Reduce Breathing to 0.0
				CurrentVolume_Breathing -= 0.2
				Sound.SetInstanceVolume(Breathing_SoundInstance, CurrentVolume_Breathing)
		EndIf
		
	
		If(CurrentVolume_Choking > ChangeVolume_Choking) ; Reduce Choking to 0.0
				CurrentVolume_Choking -= 0.2
				Sound.SetInstanceVolume(Choking_SoundInstance, CurrentVolume_Choking)
		EndIf
		
		If(CurrentVolume_Coughing > ChangeVolume_Coughing) ; Reduce Coughing to 0.0
				CurrentVolume_Coughing -= 0.2
				Sound.SetInstanceVolume(Coughing_SoundInstance, CurrentVolume_Coughing)
		EndIf
			
		If(CurrentVolume_Choking == ChangeVolume_Choking && CurrentVolume_Breathing == ChangeVolume_Breathing && CurrentVolume_Coughing == ChangeVolume_Coughing) ; Check Choking, Breathing 0.0
			If(CurrentVolume_Sprinting < ChangeVolume_Sprinting) ; Increase Sprinting to 1.0
					CurrentVolume_Sprinting += 0.2
					Sound.SetInstanceVolume(Sprinting_SoundInstance, CurrentVolume_Sprinting)
			EndIf
		EndIf
	
	
	ElseIf(ChangeVolume_Choking == 1.0)
	
		If(CurrentVolume_Breathing > ChangeVolume_Breathing) ; Reduce Breathing to 0.0
				CurrentVolume_Breathing -= 0.2
				Sound.SetInstanceVolume(Breathing_SoundInstance, CurrentVolume_Breathing)
		EndIf
		
	
		If(CurrentVolume_Sprinting > ChangeVolume_Sprinting) ; Reduce Sprinting to 0.0
				CurrentVolume_Sprinting -= 0.2
				Sound.SetInstanceVolume(Sprinting_SoundInstance, CurrentVolume_Sprinting)
		EndIf
		
		If(CurrentVolume_Coughing > ChangeVolume_Coughing) ; Reduce Choking to 0.0
				CurrentVolume_Coughing -= 0.2
				Sound.SetInstanceVolume(Coughing_SoundInstance, CurrentVolume_Coughing)
		EndIf
			
		If(CurrentVolume_Sprinting == ChangeVolume_Sprinting && CurrentVolume_Breathing == ChangeVolume_Breathing && CurrentVolume_Coughing == ChangeVolume_Coughing) ; Check Choking, Breathing 0.0
			If(CurrentVolume_Choking < ChangeVolume_Choking) ; Increase Sprinting to 1.0
					CurrentVolume_Choking += 0.2
					Sound.SetInstanceVolume(Choking_SoundInstance, CurrentVolume_Choking)
			EndIf
		EndIf
	
	
	ElseIf(ChangeVolume_Coughing == 1.0)
	
		If(CurrentVolume_Breathing > ChangeVolume_Breathing) ; Reduce Breathing to 0.0
				CurrentVolume_Breathing -= 0.2
				Sound.SetInstanceVolume(Breathing_SoundInstance, CurrentVolume_Breathing)
		EndIf
		
		If(CurrentVolume_Sprinting > ChangeVolume_Sprinting) ; Reduce Sprinting to 0.0
				CurrentVolume_Sprinting -= 0.2
				Sound.SetInstanceVolume(Sprinting_SoundInstance, CurrentVolume_Sprinting)
		EndIf
		
		If(CurrentVolume_Choking > ChangeVolume_Choking) ; Reduce Choking to 0.0
				CurrentVolume_Choking -= 0.2
				Sound.SetInstanceVolume(Choking_SoundInstance, CurrentVolume_Choking)
		EndIf
			
		If(CurrentVolume_Sprinting == ChangeVolume_Sprinting && CurrentVolume_Breathing == ChangeVolume_Breathing && CurrentVolume_Choking == ChangeVolume_Choking) ; Check Choking, Breathing, Sprinting 0.0
			If(CurrentVolume_Coughing < ChangeVolume_Coughing) ; Increase Coughing to 1.0
					CurrentVolume_Coughing += 0.2
					Sound.SetInstanceVolume(Coughing_SoundInstance, CurrentVolume_Coughing)
			EndIf
		EndIf
		
		
	ElseIf (GoToNoSound)
		
		If(CurrentVolume_Breathing > ChangeVolume_Breathing) ; Reduce Breathing to 0.0
				CurrentVolume_Breathing -= 0.2
				Sound.SetInstanceVolume(Breathing_SoundInstance, CurrentVolume_Breathing)
		EndIf
		
		If(CurrentVolume_Sprinting > ChangeVolume_Sprinting) ; Reduce Sprinting to 0.0
				CurrentVolume_Sprinting -= 0.2
				Sound.SetInstanceVolume(Sprinting_SoundInstance, CurrentVolume_Sprinting)
		EndIf
		
		If(CurrentVolume_Choking > ChangeVolume_Choking) ; Reduce Choking to 0.0
				CurrentVolume_Choking -= 0.2
				Sound.SetInstanceVolume(Choking_SoundInstance, CurrentVolume_Choking)
		EndIf
	
		If(CurrentVolume_Coughing > ChangeVolume_Coughing) ; Reduce Choking to 0.0
			CurrentVolume_Coughing -= 0.2
			Sound.SetInstanceVolume(Coughing_SoundInstance, CurrentVolume_Coughing)
		EndIf
		
	EndIf
	
	If (CurrentVolume_Breathing != ChangeVolume_Breathing) || (CurrentVolume_Sprinting != ChangeVolume_Sprinting) || (CurrentVolume_Choking != ChangeVolume_Choking) || (CurrentVolume_Coughing != ChangeVolume_Coughing )
		If ResetCounter > 11
			WriteLine(Log, "Reset...")
			NoSounds()
		EndIf
		ResetCounter += 1
		StartTimer(0.5, UpdateTimer)
		WriteLine(Log, "Changing Sound Volume | Current: " + CurrentVolume_Breathing + " " + CurrentVolume_Sprinting + " " + CurrentVolume_Choking + " " + CurrentVolume_Coughing + " | To: " + ChangeVolume_Breathing + " " + ChangeVolume_Sprinting + " " + ChangeVolume_Choking + " " + ChangeVolume_Coughing + " " + GoToNoSound)
	EndIf
EndEvent

; Functions
;---------------------------------------------

Function InvokeChanged(bool abPlayerInConversation)
	WriteLine(Log, "InvokeChanged(abPlayerInConversation='"+abPlayerInConversation+"')")

	var[] arguments = new var[1]
	arguments[0] = abPlayerInConversation
	self.SendCustomEvent("OnDialogue", arguments)
EndFunction

Function ChangeInstanceVolume(float afVolume_Breathing, float afVolume_Sprinting, float afVolume_Choking, float afVolume_Coughing)
	CancelTimer(UpdateTimer)
	bool BreathingChange = false
	bool SprintingChange = false
	bool ChokingChange = false
	bool CoughingChange = false
	GoToNoSound = false
	
	If (CurrentVolume_Breathing != afVolume_Breathing)
		ChangeVolume_Breathing = afVolume_Breathing
		BreathingChange = true
	EndIf
	
	If (CurrentVolume_Sprinting != afVolume_Sprinting)
		ChangeVolume_Sprinting = afVolume_Sprinting
		SprintingChange = true
	EndIf
	
	If (CurrentVolume_Choking != afVolume_Choking)
		ChangeVolume_Choking = afVolume_Choking
		ChokingChange = true
	EndIf
	
	If (CurrentVolume_Coughing != afVolume_Coughing)
		ChangeVolume_Coughing = afVolume_Coughing
		CoughingChange = true
	EndIf
	
	If (BreathingChange || SprintingChange || ChokingChange || CoughingChange)
		WriteLine(Log, "Changing Sound Volume | Current: " + CurrentVolume_Breathing + " " + CurrentVolume_Sprinting + " " + CurrentVolume_Choking + " " + CurrentVolume_Coughing + " | To: " + afVolume_Breathing + " " + afVolume_Sprinting + " " + afVolume_Choking + " " + afVolume_Coughing + "| Differences")
		Utility.Wait(0.1) ; Might be un-needed? Causes delay to stop/start sprinting
		ResetCounter = 0
		StartTimer(0.1, UpdateTimer)
	EndIf
	
EndFunction

Function ChangeInstanceVolumeNone() ; changes volume gradually to none
	GoToNoSound = true
	ChangeVolume_Breathing = 0.0
	ChangeVolume_Choking = 0.0
	ChangeVolume_Coughing = 0.0
	ChangeVolume_Sprinting = 0.0
	ResetCounter = 0
	StartTimer(0.1, UpdateTimer)
EndFunction

Function NoSounds()
	CancelTimer(UpdateTimer)
	GoToNoSound = true
	CurrentVolume_Breathing = 0.0
	CurrentVolume_Sprinting = 0.0
	CurrentVolume_Choking = 0.0
	CurrentVolume_Coughing = 0.0
	ChangeVolume_Breathing = 0.0
	ChangeVolume_Choking = 0.0
	ChangeVolume_Coughing = 0.0
	ChangeVolume_Sprinting = 0.0
	ResetCounter = 0
	Sound.SetInstanceVolume(Breathing_SoundInstance, CurrentVolume_Breathing)
	Sound.SetInstanceVolume(Choking_SoundInstance, CurrentVolume_Choking)
	Sound.SetInstanceVolume(Sprinting_SoundInstance, CurrentVolume_Sprinting)
	Sound.SetInstanceVolume(Coughing_SoundInstance, CurrentVolume_Coughing)
	Utility.Wait(0.1)
	
EndFunction

bool Function Play(Sound akSound)
	Utility.Wait(1.0)
	SoundInstance = AudioPlay(akSound, Log)
	If (SoundInstance)
		return true
	Else
		return false
	EndIf
EndFunction


Function Stop()
	If (AudioStop(SoundInstance, Log))
		SoundInstance = -1
	EndIf
EndFunction

Function InstantChange(int option)
	If option == 1 ; Choking
		CancelTimer(UpdateTimer)
		CurrentVolume_Breathing = 0.0
		CurrentVolume_Sprinting = 0.0
		CurrentVolume_Choking = 1.0
		CurrentVolume_Coughing = 0.0
		ChangeVolume_Breathing = 0.0
		ChangeVolume_Choking = 1.0
		ChangeVolume_Coughing = 0.0
		ChangeVolume_Sprinting = 0.0
		ResetCounter = 0
		Sound.SetInstanceVolume(Breathing_SoundInstance, CurrentVolume_Breathing)
		Sound.SetInstanceVolume(Sprinting_SoundInstance, CurrentVolume_Sprinting)
		Sound.SetInstanceVolume(Choking_SoundInstance, CurrentVolume_Choking)
		Sound.SetInstanceVolume(Coughing_SoundInstance, CurrentVolume_Coughing)
		Utility.Wait(0.1)
		WriteLine(Log, "Instant Change to Choking.")
	ElseIf option == 2 ; No Sound
		WriteLine(Log, "Instant Change to No Sounds.")
		NoSounds()
	EndIf
EndFunction

; Globals
;---------------------------------------------

int Function AudioPlay(Sound akSound, UserLog aLog = none)
	int iSoundInstance
	If (akSound)
		Utility.Wait(0.2)
		Breathing_SoundInstance = akSound.Play(Player)
		Sound.SetInstanceVolume(Breathing_SoundInstance, 1.0)
		CurrentVolume_Breathing = 1.0
		
		Sprinting_SoundInstance = NuclearWinter_GearSprintingSFX.Play(Player)
		Sound.SetInstanceVolume(Sprinting_SoundInstance, 0.0)
		CurrentVolume_Sprinting = 0.0

		Choking_SoundInstance = NuclearWinter_GearChokingSFX.Play(Player)
		Sound.SetInstanceVolume(Choking_SoundInstance, 0.0)
		CurrentVolume_Choking = 0.0

		Coughing_SoundInstance = NuclearWinter_GearCoughingSFX.Play(Player)
		Sound.SetInstanceVolume(Coughing_SoundInstance, 0.0)
		CurrentVolume_Coughing = 0.0
		
		iSoundInstance = Breathing_SoundInstance
		WriteLine(aLog, "Playing the sound '"+akSound+"' with instance ID '"+iSoundInstance+"'.")
		WriteLine(aLog, "Playing the sound '"+NuclearWinter_GearSprintingSFX+"' with instance ID '"+Sprinting_SoundInstance+"'.")
		WriteLine(aLog, "Playing the sound '"+NuclearWinter_GearChokingSFX+"' with instance ID '"+Choking_SoundInstance+"'.")
		WriteLine(aLog, "Playing the sound '"+NuclearWinter_GearCoughingSFX+"' with instance ID '"+Coughing_SoundInstance+"'.")
		return iSoundInstance
	Else
		WriteLine(aLog, "Cannot play a none sound.")
		return -1
	EndIf
EndFunction


bool Function AudioStop(int aiInstanceID, UserLog aLog = none)
	If (aiInstanceID != -1) ;&& aiInstanceID != 0)
		NoSounds()
		Sound.StopInstance(Breathing_SoundInstance)
		Utility.Wait(0.1)
		Sound.StopInstance(Sprinting_SoundInstance)
		Utility.Wait(0.1)
		Sound.StopInstance(Choking_SoundInstance)
		Utility.Wait(0.1)
		Sound.StopInstance(Coughing_SoundInstance)
		Utility.Wait(0.1)
		WriteLine(aLog, "Stopping the sound instance ID '"+aiInstanceID+"'.")
		return true
	Else
		WriteLine(aLog, "Could not stop the invalid sound instance ID '"+aiInstanceID+"'.")
		return false
	EndIf
EndFunction


; Properties
;---------------------------------------------

Group Properties
	 Spell Property GasMask_Condition_IsPlayerInConversation Auto Const Mandatory
EndGroup


Group Conditions
	bool Property CanPlay Hidden
		bool Function Get()
			If (Player.IsTalking() == false || Sprint)
				return true
			Else
				WriteLine(Log, "Cannot play sound while the player is talking.")
				return false
			EndIf
		EndFunction
	EndProperty
	
	bool Property Sprint Hidden
		bool Function Get()
			If Player.IsSprinting()
				return true
			Else
				return false
			EndIf
		EndFunction
	EndProperty
EndGroup

Group Variables
	Sound Property NuclearWinter_GearSprintingSFX Auto Const Mandatory
	Sound Property NuclearWinter_GearChokingSFX Auto Const Mandatory
	Sound Property NuclearWinter_GearCoughingSFX Auto Const Mandatory
	int Property UpdateTimer Auto const
	float Property CurrentVolume_Breathing Auto
	float Property CurrentVolume_Sprinting Auto
	float Property CurrentVolume_Choking Auto
	float Property CurrentVolume_Coughing Auto
EndGroup
