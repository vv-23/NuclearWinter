Scriptname NuclearWinter:Player:ParadoxicalUndressing extends ActiveMagicEffect 
{QUST:Winter_Player}
import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log
Actor Player 
int UnequipTimer = 0

Event OnInIt()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Freezing"
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Player = Game.GetPlayer()
	StartTimer(2,UnequipTimer)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	CancelTimer(UnequipTimer)
EndEvent

Event OnTimer(int aiTimerID)
	
	If aiTimerID == UnequipTimer
		Player.UnequipItemSlot(0)
		Player.UnequipItemSlot(1)
		;Player.UnequipItemSlot(32)
		Player.UnequipItemSlot(3)
		Player.UnequipItemSlot(4)
		Player.UnequipItemSlot(5)
		Player.UnequipItemSlot(6)
		Player.UnequipItemSlot(7)
		Player.UnequipItemSlot(8)
		Player.UnequipItemSlot(9)
		Player.UnequipItemSlot(10)
		Player.UnequipItemSlot(11)
		Player.UnequipItemSlot(12)
		Player.UnequipItemSlot(13)
		Player.UnequipItemSlot(14)
		Player.UnequipItemSlot(15)
		Player.UnequipItemSlot(16)
		Player.UnequipItemSlot(17)
		Player.UnequipItemSlot(18)
		Player.UnequipItemSlot(19)
		Player.UnequipItemSlot(10)
		Player.UnequipItemSlot(21)
		Player.UnequipItemSlot(24)
		Player.UnequipItemSlot(25)
		Player.UnequipItemSlot(26)
		Player.UnequipItemSlot(27)
		Player.UnequipItemSlot(28)
		StartTimer(2,UnequipTimer)
	EndIf
	
EndEvent
