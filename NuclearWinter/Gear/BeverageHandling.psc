Scriptname NuclearWinter:Gear:BeverageHandling extends NuclearWinter:Core:Optional
{QUST:Winter_Player}
import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log

int RegisterTimer = 0
int MeltTimer = 1
bool SpellsApplied = false
bool first = true

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Beverages"
	SpellsToIgnore = new Int[Winter_BeverageSpells.GetSize()]
EndEvent

Event OnEnable()
	If FoodToggle
		SpellsToIgnore = new Int[Winter_BeverageSpells.GetSize()]
		AddInventoryEventFilter(Winter_Beverages)
		RegisterForRemoteEvent(Player, "OnItemAdded")
		RegisterForRemoteEvent(Player, "OnItemRemoved")
		RegisterForRemoteEvent(Player, "OnItemEquipped")
	EndIf
EndEvent

Event OnDisable()
	CancelTimerGameTime(MeltTimer)
	RemoveAllInventoryEventFilters()
	UnRegisterForRemoteEvent(Player, "OnItemAdded")
	UnRegisterForRemoteEvent(Player, "OnItemRemoved")
	UnRegisterForRemoteEvent(Player, "OnItemEquipped")
EndEvent

Event OnTimerGameTime(int aiTimerID)
	If aiTimerID == MeltTimer && Thermodynamics.Temperature >= 32
		int i = 0
		While i < Winter_Beverages.GetSize()
			If Player.GetItemCount(Winter_FrozenBeverages.GetAt(i)) > 0
				int ItemCount = Player.GetItemCount(Winter_FrozenBeverages.GetAt(i))
				Player.RemoveItem(Winter_FrozenBeverages.GetAt(i),ItemCount, true)
				Player.AddItem(Winter_Beverages.GetAt(i), ItemCount, true)
			EndIf
			i += 1
		EndWhile
	EndIf
EndEvent

Event NuclearWinter:World:Thermodynamics.OnChanged(World:Thermodynamics akSender, var[] arguments)
	If Thermodynamics.Temperature < 32 && SpellsApplied == False
		CancelTimerGameTime(MeltTimer)
		SpellsApplied = true
		int i = 0
		While i < Winter_Beverages.GetSize()
			int j = 0
			While j < Player.GetItemCount(Winter_Beverages.GetAt(i))
				(Winter_BeverageSpells.GetAt(i) as Spell).Cast(Player, Player)
				j += 1
			EndWhile
			i += 1
		EndWhile
	ElseIf Thermodynamics.Temperature >= 32 && SpellsApplied
		SpellsApplied = false
		int i = 0
		While i < Winter_BeverageSpells.GetSize()
			Player.DispelSpell((Winter_BeverageSpells.GetAt(i) as Spell))
			i += 1
		EndWhile
		StartTimerGameTime(2,MeltTimer)
	EndIf
EndEvent

Event ObjectReference.OnItemAdded(ObjectReference akObjRef, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	WriteLine(Log, "BeverageHandling: Adding Spell Food | aiItemCount: " + aiItemCount)
	If Thermodynamics.Temperature < 32
		int i = 0
		While i < aiItemCount
				(Winter_BeverageSpells.GetAt(Winter_Beverages.Find(akBaseItem)) as Spell).Cast(Player, Player)
				i += 1
				;Utility.Wait(0.2)
		EndWhile
	EndIf
	If first
		int button = Winter_BeverageHelp.Show()
		If button == 1
			first = false
		EndIf
	EndIf
EndEvent

Event ObjectReference.OnItemRemoved(ObjectReference akObjRef, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	If (akDestContainer != None) || (akDestContainer != Player)
		WriteLine(Log, "BeverageHandling: Removing " + aiItemCount + " Beverages into a container, turn into cold")
		akDestContainer.RemoveItem(akBaseItem,aiItemCount)
		akDestContainer.AddItem(Winter_FrozenBeverages.GetAt(Winter_Beverages.Find(akBaseItem)), aiItemCount, true)
		SpellsToIgnore[Winter_Beverages.Find(akBaseItem)] += aiItemCount
	Else
		WriteLine(Log, "BeverageHandling: Removing " + aiItemCount + " Beverages into world, turn into cold and delete original reference")
		akItemReference.Delete()
		Player.AddItem(Winter_FrozenBeverages.GetAt(Winter_Beverages.Find(akBaseItem)), aiItemCount, true)
		Player.DropObject(Winter_FrozenBeverages.GetAt(Winter_Beverages.Find(akBaseItem)), aiItemCount)
		SpellsToIgnore[Winter_Beverages.Find(akBaseItem)] += aiItemCount
	EndIf
EndEvent

Event Actor.OnItemEquipped(Actor akActor, Form akBaseObject, ObjectReference akReference)
	Utility.Wait(0.1)
	If akBaseObject != None
	  If Winter_FrozenBeverages.HasForm(akBaseObject)
		Player.AddItem(akBaseObject, 1, true)
		Winter_FrozenBeverageMSG.Show()
	  ElseIf Winter_Alcohol.HasForm(akBaseObject)
		WriteLine(Log, "BeverageHandling: Alcohol Consumed, add heating spell")
		Winter_BeverageWarming.Cast(Player,Player)
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

Group Context
	World:Thermodynamics Property Thermodynamics Auto Const Mandatory
EndGroup

Group Properties
	GlobalVariable Property Winter_FoodToggle Auto
	int[] Property SpellsToIgnore Auto
	Spell Property Winter_BeverageWarming Auto
	FormList Property Winter_Alcohol Auto
	FormList Property Winter_FrozenBeverages Auto
	FormList Property Winter_Beverages Auto
	FormList Property Winter_BeverageSpells Auto
	Message Property Winter_FrozenBeverageMSG Auto
	Message Property Winter_BeverageHelp Auto
	
	bool Property FoodToggle
		bool Function Get()
			bool value = Winter_FoodToggle.GetValueInt() as bool
			return (value)
		EndFunction
		Function Set(bool value)
		
			If Winter_FoodToggle.GetValueInt() == 0
				SpellsToIgnore = new Int[Winter_BeverageSpells.GetSize()]
				AddInventoryEventFilter(Winter_Beverages)
				RegisterForRemoteEvent(Player, "OnItemAdded")
				RegisterForRemoteEvent(Player, "OnItemRemoved")
				RegisterForRemoteEvent(Player, "OnItemEquipped")
			Else
				CancelTimerGameTime(MeltTimer)
				RemoveAllInventoryEventFilters()
				UnRegisterForRemoteEvent(Player, "OnItemAdded")
				UnRegisterForRemoteEvent(Player, "OnItemRemoved")
				UnRegisterForRemoteEvent(Player, "OnItemEquipped")
			EndIf
		
		EndFunction 
	EndProperty
EndGroup
