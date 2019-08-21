Scriptname NuclearWinter:Gear:FilterReplace extends NuclearWinter:Core:Optional
import NuclearWinter
import NuclearWinter:Player:Animation
import Shared:Log

UserLog Log

bool CanPlayAnim = true
bool UsedFilterSlow = false
int TimerID = 0

; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Gear"
EndEvent


Event OnEnable()
	If (TryAdd())
		WriteLine(Log, "Added Fast Filter Replace item to the player for startup.")
	Else
		WriteLine(Log, "The player already has a Fast Filter Replace item for startup.")
	EndIf
	CanPlayAnim = true
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForRemoteEvent(Player, "OnItemAdded")
	RegisterForRemoteEvent(Player, "OnItemRemoved")
	AddInventoryEventFilter(NuclearWinter_GearFilter)
	RegisterForCustomEvent(Filter, "OnReplaced")
EndEvent


Event OnDisable()
	CanPlayAnim = false
	CancelTimer(TimerID)
	RemoveInventoryEventFilter(NuclearWinter_GearFilter)
	UnRegisterForRemoteEvent(Player, "OnItemAdded")
	UnRegisterForRemoteEvent(Player, "OnItemRemoved")
	UnregisterForRemoteEvent(Player, "OnItemEquipped")
	UnregisterForCustomEvent(Filter, "OnReplaced")
EndEvent


; Methods
;---------------------------------------------

State ActiveState

	Event ObjectReference.OnItemAdded(ObjectReference akSender, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		Utility.wait(0.5)
		If (Player.GetItemCount(NuclearWinter_GearFilter) > 0) && (Player.GetItemCount(NuclearWinter_GearFilterFast) == 0)
				Player.AddItem(NuclearWinter_GearFilterFast, 1, true)
		EndIf
	EndEvent
	
	Event ObjectReference.OnItemRemoved(ObjectReference akSender, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		Utility.wait(0.5)
		If (Player.GetItemCount(NuclearWinter_GearFilter) == 0) && (Player.GetItemCount(NuclearWinter_GearFilterFast) > 0)
				Player.RemoveItem(NuclearWinter_GearFilterFast, 1, true)
		EndIf
	EndEvent
	
	Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
			Utility.wait(1.0)
			If (akBaseObject == NuclearWinter_GearFilter)
				If ((Filter.Charge != 100) && Filter.Replace())
					WriteLine(Log, "Adding a dirty filter item to the player.")
					UsedFilterSlow = true
					Player.AddItem(NuclearWinter_GearFilterDirty, 1)
				Else
					WriteLine(Log, "Refunding filter item, player does not need to replace filters at this time.")
					Player.AddItem(NuclearWinter_GearFilter, 1, true)
				EndIf
			ElseIf (akBaseObject == NuclearWinter_GearFilterFast)
				If (Filter.Charge != 100) && (Filter.Replace()) && (Filter.Quantity > 0)
					WriteLine(Log, "Used a Fast Filter replace.")
					UsedFilterSlow = false
					;Player.AddItem(NuclearWinter_GearFilterDirty, 1)
					Player.RemoveItem(NuclearWinter_GearFilter, 1, true)
				Else
					WriteLine(Log, "Refunding filter item, player does not need to replace filters at this time.")
					If (Player.GetItemCount(NuclearWinter_GearFilter) > 0)
						Player.AddItem(NuclearWinter_GearFilterFast, 1, abSilent = true)
					EndIf
				EndIf
			EndIf
	EndEvent


	Event NuclearWinter:Gear:Filter.OnReplaced(Gear:Filter akSender, var[] arguments)
		Utility.wait(0.5)
		If CanPlayAnim
			If (Player.GetItemCount(NuclearWinter_GearFilterFast) == 0 && UsedFilterSlow == false)
				If (Player.GetItemCount(NuclearWinter_GearFilter) > 0)
					Player.AddItem(NuclearWinter_GearFilterFast, 1, abSilent = true)
				EndIf
				If(Mask.FormID == 0x001184C1) ; GasMaskwithGoggles
					If(IsFirstPerson)
						IdlePlay(Player, GasMaskwithGoggles_1stPUseFilterFastOnSelf, Log)
					Else
						IdlePlay(Player, GasMaskwithGoggles_3rdPUseFilterFastOnSelf, Log)
					EndIf
				ElseIf(Mask.FormID == 0x000787D8) ; SingleVisor
					If(IsFirstPerson)
						IdlePlay(Player, SingleVisor_1stPUseFilterFastOnSelf, Log)
					Else
						IdlePlay(Player, SingleVisor_3rdPUseFilterFastOnSelf, Log)
					EndIf
				ElseIf(Mask.FormID == 0x00007A77) ; M1A211
					If(IsFirstPerson)
						IdlePlay(Player, M1A211_1stPUseFilterFastOnSelf, Log)
					Else
						IdlePlay(Player, M1A211_3rdPUseFilterFastOnSelf, Log)
					EndIf
				Else
					If(IsFirstPerson)
						IdlePlay(Player, GasMaskwithGoggles_1stPUseFilterFastOnSelf, Log)
					;Else
						;IdlePlay(Player, GasMaskwithGoggles_3rdPUseFilterFastOnSelf, Log)
					EndIf
				EndIf

				NuclearWinter_GearFilterFastReplaceSFX.Play(Player)
				WriteLine(Log, "Refunding the filter replace item.")
				
				If(IsFirstPerson == false)
					Mask.AnimationEquip = 3
					Player.Unequipitem(Mask.Equipped, true, true)
					Utility.Wait(3.05)
					Player.EquipItem(Mask.Equipped, False, True)
					WriteLine(Log, "AnimationEquip = " + Mask.AnimationEquip)
					Mask.AnimationEquip = 0
				EndIf
			ElseIf Filter.Charge == 100
			
				If(Mask.FormID == 0x001184C1) ; GasMaskwithGoggles
					If(IsFirstPerson)
						IdlePlay(Player, GasMaskwithGoggles_1stPUseFilterSlowOnSelf, Log)
					Else
						IdlePlay(Player, GasMaskwithGoggles_3rdPUseFilterSlowOnSelf, Log)
					EndIf
				ElseIf(Mask.FormID == 0x000787D8) ; SingleVisor
					If(IsFirstPerson)
						IdlePlay(Player, SingleVisor_1stPUseFilterSlowOnSelf, Log)
					Else
						IdlePlay(Player, SingleVisor_3rdPUseFilterSlowOnSelf, Log)
					EndIf
				ElseIf(Mask.FormID == 0x00007A77) ; M1A211
					If(IsFirstPerson)
						IdlePlay(Player, M1A211_1stPUseFilterSlowOnSelf, Log)
					Else
						IdlePlay(Player, M1A211_3rdPUseFilterSlowOnSelf, Log)
					EndIf
				Else
					If(IsFirstPerson)
						IdlePlay(Player, M1A211_1stPUseFilterSlowOnSelf, Log)
					Else
						IdlePlay(Player, M1A211_3rdPUseFilterSlowOnSelf, Log)
					EndIf
				EndIf
				NuclearWinter_GearFilterReplaceSFX.Play(Player)
				
				If(IsFirstPerson == false)
					Mask.AnimationEquip = 2
					Player.Unequipitem(Mask.Equipped, true, true)
					Utility.Wait(5.8)
					Player.EquipItem(Mask.Equipped, False, True)
					WriteLine(Log, "AnimationEquip = " + Mask.AnimationEquip)
					Mask.AnimationEquip = 0
				EndIf	
			EndIf
			CanPlayAnim = false
			StartTimer(5.0,TimerID)
		EndIf
		WriteLine(Log, "A filter has been replaced.")
	EndEvent
	
	Event OnTimer(int aiTimerID)
		If aiTimerID == TimerID
			CanPlayAnim = true
		EndIf
	EndEvent
EndState



Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	{EMPTY}
EndEvent

Event ObjectReference.OnItemAdded(ObjectReference akSender, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	{EMPTY}
EndEvent

Event ObjectReference.OnItemRemoved(ObjectReference akSender, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	{EMPTY}
EndEvent

Event NuclearWinter:Gear:Filter.OnReplaced(Gear:Filter akSender, var[] arguments)
	{EMPTY}
EndEvent

;Functions
;---------------------------------------------

bool Function TryAdd()
	If (HasFilterItem == false)
		Player.AddItem(NuclearWinter_GearFilterFast, 1, true)
		return true
	Else
		return false
	EndIf
EndFunction

; Properties
;---------------------------------------------

Group Context
	Gear:Filter Property Filter Auto Const Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
EndGroup

Group Properties
	Potion Property NuclearWinter_GearFilter Auto Const Mandatory
	Potion Property NuclearWinter_GearFilterFast Auto Const Mandatory
	MiscObject Property NuclearWinter_GearFilterDirty Auto Const Mandatory
	Sound Property NuclearWinter_GearFilterReplaceSFX Auto Mandatory
	Sound Property NuclearWinter_GearFilterFastReplaceSFX Auto Mandatory
	
	Idle property GasMaskwithGoggles_1stPUseFilterFastOnSelf Auto Const Mandatory
	Idle property GasMaskwithGoggles_3rdPUseFilterFastOnSelf Auto Const Mandatory
	
	Idle property SingleVisor_1stPUseFilterFastOnSelf Auto Const Mandatory
	Idle property SingleVisor_3rdPUseFilterFastOnSelf Auto Const Mandatory
	
	Idle property M1A211_1stPUseFilterFastOnSelf Auto Const Mandatory
	Idle property M1A211_3rdPUseFilterFastOnSelf Auto Const Mandatory
	{IDLE: 1stPUseFilterFastOnSelf }
	
	Idle property GasMaskwithGoggles_1stPUseFilterSlowOnSelf Auto Const Mandatory
	Idle property GasMaskwithGoggles_3rdPUseFilterSlowOnSelf Auto Const Mandatory
	
	Idle property SingleVisor_1stPUseFilterSlowOnSelf Auto Const Mandatory
	Idle property SingleVisor_3rdPUseFilterSlowOnSelf Auto Const Mandatory
	
	Idle property M1A211_1stPUseFilterSlowOnSelf Auto Const Mandatory
	Idle property M1A211_3rdPUseFilterSlowOnSelf Auto Const Mandatory
	{IDLE: "1stPUseFilterSlowOnSelf"}
EndGroup

Group Setup
	bool Property HasFilterItem Hidden
		bool Function Get()
			return Player.GetItemCount(NuclearWinter_GearFilterFast) >= 1
		EndFunction
	EndProperty
EndGroup

Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Player.GetAnimationVariableBool("IsFirstPerson")
		EndFunction
	EndProperty
EndGroup

