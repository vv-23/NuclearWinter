Scriptname NuclearWinter:Gear:FoodHandling extends NuclearWinter:Core:Optional
{QUST:Winter_Gear}
import NuclearWinter
; import NuclearWinter:World
import Shared:Log

UserLog Log

Spell FoodHeatExpiration
int RegisterTimer = 0

bool first = true

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Food"
	SpellsToIgnore = new Int[Winter_WarmFoodSpells.GetSize()]
EndEvent

Event OnEnable()
	If FoodToggle
		SpellsToIgnore = new Int[Winter_WarmFoodSpells.GetSize()]
		AddInventoryEventFilter(Winter_WarmFoods)
		RegisterForRemoteEvent(Player, "OnItemAdded")
		RegisterForRemoteEvent(Player, "OnItemRemoved")
		RegisterForRemoteEvent(Player, "OnItemEquipped")
		int i = 0
		While i < Winter_WarmFoods.GetSize()
			int j = 0
			While j < Player.GetItemCount(Winter_WarmFoods.GetAt(i))
				(Winter_WarmFoodSpells.GetAt(i) as Spell).Cast(Player, Player)
				j += 1
			EndWhile
			i += 1
		EndWhile
	EndIf
EndEvent

Event OnDisable()
	RemoveAllInventoryEventFilters()
	UnRegisterForRemoteEvent(Player, "OnItemAdded")
	UnRegisterForRemoteEvent(Player, "OnItemRemoved")
	UnRegisterForRemoteEvent(Player, "OnItemEquipped")
EndEvent

Event ObjectReference.OnItemAdded(ObjectReference akObjRef, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	WriteLine(Log, "FoodHandling: Adding Spell Food | aiItemCount: " + aiItemCount)
	int i = 0
	While i < aiItemCount
			(Winter_WarmFoodSpells.GetAt(Winter_WarmFoods.Find(akBaseItem)) as Spell).Cast(Player, Player)
			i += 1
			;Utility.Wait(0.2)
	EndWhile
	If first
		int button = Winter_FoodHelp.Show()
		If button == 1
			first = false
		EndIf
	EndIf
EndEvent

Event ObjectReference.OnItemRemoved(ObjectReference akObjRef, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	If (akDestContainer != None) || (akDestContainer != Player)
		WriteLine(Log, "FoodHandling: Removing + aiItemCount + Warm Food into a container, turn into cold")
		akDestContainer.RemoveItem(akBaseItem,aiItemCount)
		akDestContainer.AddItem(Winter_ColdFoods.GetAt(Winter_WarmFoods.Find(akBaseItem)), aiItemCount, true)
		SpellsToIgnore[Winter_WarmFoods.Find(akBaseItem)] += aiItemCount
	Else
		WriteLine(Log, "FoodHandling: Removing " + aiItemCount + " Warm Food into world, turn into cold and delete original reference")
		akItemReference.Delete()
		Player.AddItem(Winter_ColdFoods.GetAt(Winter_WarmFoods.Find(akBaseItem)), aiItemCount, true)
		Player.DropObject(Winter_ColdFoods.GetAt(Winter_WarmFoods.Find(akBaseItem)), aiItemCount)
		SpellsToIgnore[Winter_WarmFoods.Find(akBaseItem)] += aiItemCount
	EndIf
EndEvent

Event Actor.OnItemEquipped(Actor akActor, Form akBaseObject, ObjectReference akReference)
	Utility.Wait(0.1)
	If akBaseObject != None
	  If Winter_WarmFoods.HasForm(akBaseObject)
		WriteLine(Log, "FoodHandling: Warm Food Consumed, add heating spell")
		Winter_FoodWarming.Cast(Player,Player)
	  EndIf
	EndIf
endEvent

Event OnTimer(int aiTimerID)
	If aiTimerID == RegisterTimer
		RegisterForRemoteEvent(Player, "OnItemRemoved")
	EndIf
EndEvent

; We need these for the script FoodExpire to turn Off/On registration when we remove foods so that it doesn't spawn food at our feet.
Function UnRegisterForRemoved()
	UnRegisterForRemoteEvent(Player, "OnItemRemoved")
EndFunction

Function RegisterForRemoved()
	StartTimer(2,RegisterTimer)
EndFunction

Function ResetHelpers()
	first = true
EndFunction

Group Properties
	GlobalVariable Property Winter_FoodToggle Auto
	int[] Property SpellsToIgnore Auto
	Spell Property Winter_FoodWarming Auto
	FormList Property Winter_ColdFoods Auto
	FormList Property Winter_WarmFoods Auto
	FormList Property Winter_WarmFoodSpells Auto
	Message Property Winter_FoodHelp Auto
	
	bool Property FoodToggle
		bool Function Get()
			bool value = Winter_FoodToggle.GetValueInt() as bool
			return (value)
		EndFunction
		Function Set(bool value)
			If Winter_FoodToggle.GetValueInt() == 0
				SpellsToIgnore = new Int[Winter_WarmFoodSpells.GetSize()]
				AddInventoryEventFilter(Winter_WarmFoods)
				RegisterForRemoteEvent(Player, "OnItemAdded")
				RegisterForRemoteEvent(Player, "OnItemRemoved")
				RegisterForRemoteEvent(Player, "OnItemEquipped")
				int i = 0
				While i < Winter_WarmFoods.GetSize()
					int j = 0
					While j < Player.GetItemCount(Winter_WarmFoods.GetAt(i))
						(Winter_WarmFoodSpells.GetAt(i) as Spell).Cast(Player, Player)
						j += 1
					EndWhile
					i += 1
				EndWhile
			Else
				RemoveAllInventoryEventFilters()
				UnRegisterForRemoteEvent(Player, "OnItemAdded")
				UnRegisterForRemoteEvent(Player, "OnItemRemoved")
				UnRegisterForRemoteEvent(Player, "OnItemEquipped")
			EndIf	
			Winter_FoodToggle.SetValueInt(value as Int)
		EndFunction 
	EndProperty

EndGroup
