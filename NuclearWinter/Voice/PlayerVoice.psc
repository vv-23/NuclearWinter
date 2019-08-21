ScriptName NuclearWinter:Voice:PlayerVoice extends NuclearWinter:Core:Required
import DefaultObject
import NuclearWinter
import Shared:Log

UserLog Log
DefaultObject Player1stVoiceOutputModel_DO
DefaultObject Player3rdVoiceOutputModel_DO
string Player1st = "Player1stVoiceOutputModel_DO"
string Player3rd = "Player3rdVoiceOutputModel_DO"
Form Player1stVoice
Form Player3rdVoice

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "PlayerVoice"
EndEvent

Event OnEnable()
	Player1stVoice = GetDefaultObject(Player1st)
	Player3rdVoice = GetDefaultObject(Player3rd)
	RegisterForCustomEvent(Mask, "OnChanged")
EndEvent


Event OnDisable()
	UnregisterForCustomEvent(Mask, "OnChanged")
EndEvent

Event NuclearWinter:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
	WriteLine(Log, "PlayerVoice: Mask.OnChanged")
	If (Mask.IsGasMask && Mask.IsPowerArmor == false)
		Player1stVoiceOutputModel_DO.Set(GasMask_SOMDialoguePlayer2D)
		Player3rdVoiceOutputModel_DO.Set(GasMask_SOMDialoguePlayer3D)
		WriteLine(Log, "Voice set to Gas Mask: " + Player1stVoiceOutputModel_DO.Get())
	Else
		Player1stVoiceOutputModel_DO.Set(SOMDialoguePlayer2D)
		Player3rdVoiceOutputModel_DO.Set(SOMDialoguePlayer3D)
		WriteLine(Log, "Voice set to Default: " + Player1stVoiceOutputModel_DO.Get())
	EndIf
EndEvent

;Properties ----------------------------------------
Group Properties
	Gear:Mask Property Mask Auto Const Mandatory
	Form Property GasMask_SOMDialoguePlayer2D Auto Const Mandatory
	Form Property GasMask_SOMDialoguePlayer3D Auto Const Mandatory
	Form Property SOMDialoguePlayer2D Auto Const Mandatory
	Form Property SOMDialoguePlayer3D Auto Const Mandatory
EndGroup
