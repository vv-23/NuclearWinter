Scriptname NuclearWinter:Gear:LLInject extends NuclearWinter:Core:Required
{QUST:NuclearWinter_Gear}
import NuclearWinter:Context
import Shared:Log
import Shared:Papyrus

UserLog Log

bool Added = false

Event OnInitialize()
	Log = GetLog(self)
	Log.FileName = "Gear"
EndEvent

Group AlphaLL
	{First LL to add to the Vanilla LL.}
	LeveledItem Property GasMask_LOOT_Stockpile_Filters_SML Auto Const
	{The Leveled List you want to add the the Leveled Lists.}
	int Property Alpha_PlayerLevel = 1 Auto Const
	{Choose a player level at which to add the LL to Leveled Lists. This can be overwritten for individual lists below.}
	int Property Alpha_Count = 0 Auto Const
	{Number of LLs to add to the Leveled Lists. This can be overwritten for individual lists below.}
EndGroup

Group BravoLL
	{Second LL to add to the Vanilla LL.}
	LeveledItem Property GasMask_LOOT_Vendor Auto Const
	{The Leveled List you want to add the the Leveled Lists.}
	int Property Bravo_PlayerLevel = 1 Auto Const
	{Choose a player level at which to add the LL to Leveled Lists. This can be overwritten for individual lists below.}
	int Property Bravo_Count = 0 Auto Const
	{Number of LLs to add to the Leveled Lists. This can be overwritten for individual lists below.}	
EndGroup

Group CharlieLL
	{Third LL to add to the Vanilla LL.}
	LeveledItem Property GasMask_LOOT_Vendor_Filters Auto Const
	{The Leveled List you want to add the the Leveled Lists.}
	int Property Charlie_PlayerLevel = 1 Auto Const
	{Choose a player level at which to add the LL to Leveled Lists. This can be overwritten for individual lists below.}
	int Property Charlie_Count = 0 Auto Const
	{Number of LLs to add to the Leveled Lists. This can be overwritten for individual lists below.}	
EndGroup

Group DeltaLL
	{Fourth LL to add to the Vanilla LL.}
	LeveledItem Property GasMask_LOOT_Filters Auto Const
	{The Leveled List you want to add the the Leveled Lists.}
	int Property Delta_PlayerLevel = 1 Auto Const
	{Choose a player level at which to add the LL to Leveled Lists. This can be overwritten for individual lists below.}
	int Property Delta_Count = 0 Auto Const
	{Number of LLs to add to the Leveled Lists. This can be overwritten for individual lists below.}	
EndGroup

Group FoxtrotLL
	{Fifth LL to add to the Vanilla LL.}
	LeveledItem Property GasMask_LOOT_DirtyFilters Auto Const
	{The Leveled List you want to add the the Leveled Lists.}
	int Property Foxtrot_PlayerLevel = 1 Auto Const
	{Choose a player level at which to add the LL to Leveled Lists. This can be overwritten for individual lists below.}
	int Property Foxtrot_Count = 0 Auto Const
	{Number of LLs to add to the Leveled Lists. This can be overwritten for individual lists below.}	
EndGroup

Group Foxtrot2LL
	{Sixth LL to add to the Vanilla LL.}
	LeveledItem Property GasMask_NPC_Military_Random Auto Const
	{The Leveled List you want to add the the Leveled Lists.}
	int Property Foxtrot2_PlayerLevel = 1 Auto Const
	int Property Foxtrot2_Count = 0 Auto Const
EndGroup

;------------------------------------------------------------------------

Group VanillaLL1
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property WorkshopProduceScavenge Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_1 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to WorkshopProduceScavenge. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_1 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to WorkshopProduceScavenge. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_1 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to WorkshopProduceScavenge. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_1 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to WorkshopProduceScavenge. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_1 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to WorkshopProduceScavenge. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	;-------------------------
	int Property Alpha_Count_Vanilla_LL_1 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to WorkshopProduceScavenge. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_1 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to WorkshopProduceScavenge. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_1 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to WorkshopProduceScavenge. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_1 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to WorkshopProduceScavenge. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_1 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to WorkshopProduceScavenge. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_1 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL2
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property Container_Loot_Trashcan Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_2 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to Container_Loot_Trashcan. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_2 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to Container_Loot_Trashcan. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_2 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to Container_Loot_Trashcan. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_2 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to Container_Loot_Trashcan. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_2 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to Container_Loot_Trashcan. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_2 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to Container_Loot_Trashcan. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_2 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to Container_Loot_Trashcan. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_2 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to Container_Loot_Trashcan. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_2 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to Container_Loot_Trashcan. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_2 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to Container_Loot_Trashcan. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_2 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL3
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property Container_Loot_Cooler_Raider Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_3 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to Container_Loot_Cooler_Raider. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_3 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to Container_Loot_Cooler_Raider. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_3 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to Container_Loot_Cooler_Raider. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_3 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to Container_Loot_Cooler_Raider. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_3 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to Container_Loot_Cooler_Raider. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_3 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to Container_Loot_Cooler_Raider. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_3 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to Container_Loot_Cooler_Raider. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_3 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to Container_Loot_Cooler_Raider. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_3 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to Container_Loot_Cooler_Raider. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_3 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to Container_Loot_Cooler_Raider. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_3 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL4
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property Container_Loot_DuffleBag_Guns Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_4 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to Container_Loot_DuffleBag_Guns. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_4 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to Container_Loot_DuffleBag_Guns. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_4 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to Container_Loot_DuffleBag_Guns. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_4 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to Container_Loot_DuffleBag_Guns. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_4 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to Container_Loot_DuffleBag_Guns. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_4 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to Container_Loot_DuffleBag_Guns. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_4 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to Container_Loot_DuffleBag_Guns. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_4 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to Container_Loot_DuffleBag_Guns. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_4 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to Container_Loot_DuffleBag_Guns. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_4 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to Container_Loot_DuffleBag_Guns. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_4 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL5
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property Container_Loot_Medkit_Chems_Raider Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_5 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to Container_Loot_Medkit_Chems_Raider. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_5 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to Container_Loot_Medkit_Chems_Raider. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_5 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to Container_Loot_Medkit_Chems_Raider. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_5 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to Container_Loot_Medkit_Chems_Raider. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_5 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to Container_Loot_Medkit_Chems_Raider. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_5 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to Container_Loot_Medkit_Chems_Raider. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_5 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to Container_Loot_Medkit_Chems_Raider. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_5 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to Container_Loot_Medkit_Chems_Raider. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_5 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to Container_Loot_Medkit_Chems_Raider. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_5 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to Container_Loot_Medkit_Chems_Raider. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_5 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL6
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property Container_Loot_Suitcase_Armor_Raider Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_6 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to Container_Loot_Suitcase_Armor_Raider. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_6 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to Container_Loot_Suitcase_Armor_Raider. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_6 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to Container_Loot_Suitcase_Armor_Raider. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_6 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to Container_Loot_Suitcase_Armor_Raider. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_6 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to Container_Loot_Suitcase_Armor_Raider. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_6 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to Container_Loot_Suitcase_Armor_Raider. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_6 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to Container_Loot_Suitcase_Armor_Raider. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_6 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to Container_Loot_Suitcase_Armor_Raider. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_6 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to Container_Loot_Suitcase_Armor_Raider. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_6 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to Container_Loot_Suitcase_Armor_Raider. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_6 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL7
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property Container_Loot_Toolbox_Raider Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_7 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to Container_Loot_Toolbox_Raider. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_7 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to Container_Loot_Toolbox_Raider. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_7 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to Container_Loot_Toolbox_Raider. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_7 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to Container_Loot_Toolbox_Raider. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_7 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to Container_Loot_Toolbox_Raider. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_7 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to Container_Loot_Toolbox_Raider. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_7 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to Container_Loot_Toolbox_Raider. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_7 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to Container_Loot_Toolbox_Raider. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_7 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to Container_Loot_Toolbox_Raider. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_7 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to Container_Loot_Toolbox_Raider. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_7 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL8
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property Container_Loot_Cabinet_Garage Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_8 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to Container_Loot_Cabinet_Garage. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_8 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to Container_Loot_Cabinet_Garage. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_8 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to Container_Loot_Cabinet_Garage. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_8 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to Container_Loot_Cabinet_Garage. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_8 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to Container_Loot_Cabinet_Garage. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_8 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to Container_Loot_Cabinet_Garage. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_8 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to Container_Loot_Cabinet_Garage. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_8 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to Container_Loot_Cabinet_Garage. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_8 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to Container_Loot_Cabinet_Garage. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_8 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to Container_Loot_Cabinet_Garage. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_8 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL9
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property VL_Vendor_General Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_9 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to VL_Vendor_General. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_9 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to VL_Vendor_General. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_9 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to VL_Vendor_General. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_9 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to VL_Vendor_General. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_9 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to VL_Vendor_General. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_9 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to VL_Vendor_General. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_9 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to VL_Vendor_General. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_9 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to VL_Vendor_General. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_9 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to VL_Vendor_General. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_9 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to VL_Vendor_General. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_9 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL10
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property LLI_Vendor_Items_Small_Basic Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_10 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to LLI_Vendor_Items_Small_Basic. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_10 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to LLI_Vendor_Items_Small_Basic. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_10 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to LLI_Vendor_Items_Small_Basic. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_10 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to LLI_Vendor_Items_Small_Basic. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_10 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to LLI_Vendor_Items_Small_Basic. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_10 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to LLI_Vendor_Items_Small_Basic. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_10 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to LLI_Vendor_Items_Small_Basic. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_10 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to LLI_Vendor_Items_Small_Basic. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_10 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to LLI_Vendor_Items_Small_Basic. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_10 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LLI_Vendor_Items_Small_Basic. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_10 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL11
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property VL_Vendor_Chems Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_11 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to VL_Vendor_Chems. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_11 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to VL_Vendor_Chems. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_11 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to VL_Vendor_Chems. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_11 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to VL_Vendor_Chems. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_11 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to VL_Vendor_Chems. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_11 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to VL_Vendor_Chems. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_11 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to VL_Vendor_Chems. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_11 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to VL_Vendor_Chems. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_11 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to VL_Vendor_Chems. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_11 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to VL_Vendor_Chems. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_11 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL12
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property VL_Vendor_Clothing Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_12 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to VL_Vendor_Clothing. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_12 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to VL_Vendor_Clothing. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_12 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to VL_Vendor_Clothing. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_12 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to VL_Vendor_Clothing. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_12 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to VL_Vendor_Clothing. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_12 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to VL_Vendor_Clothing. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_12 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to VL_Vendor_Clothing. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_12 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to VL_Vendor_Clothing. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_12 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to VL_Vendor_Clothing. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_12 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to VL_Vendor_Clothing. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_12 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL13
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property Container_Loot_WoodCrate_PreWar Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_13 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to Container_Loot_WoodCrate_PreWar. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_13 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to Container_Loot_WoodCrate_PreWar. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_13 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to Container_Loot_WoodCrate_PreWar. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_13 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to Container_Loot_WoodCrate_PreWar. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_13 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to Container_Loot_WoodCrate_PreWar. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_13 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to Container_Loot_WoodCrate_PreWar. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_13 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to Container_Loot_WoodCrate_PreWar. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_13 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to Container_Loot_WoodCrate_PreWar. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_13 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to Container_Loot_WoodCrate_PreWar. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_13 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to Container_Loot_WoodCrate_PreWar. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_13 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL14
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property Container_Loot_WoodCrate_Raider Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_14 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to Container_Loot_WoodCrate_Raider. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_14 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to Container_Loot_WoodCrate_Raider. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_14 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to Container_Loot_WoodCrate_Raider. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_14 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to Container_Loot_WoodCrate_Raider. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_14 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to Container_Loot_WoodCrate_Raider. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_14 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to Container_Loot_WoodCrate_Raider. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_14 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to Container_Loot_WoodCrate_Raider. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_14 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to Container_Loot_WoodCrate_Raider. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_14 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to Container_Loot_WoodCrate_Raider. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_14 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to Container_Loot_WoodCrate_Raider. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_14 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL15
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property LL_Vendor_Components_Goodneighbor_Daisy Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_15 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to LL_Vendor_Components_Goodneighbor_Daisy. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_15 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to LL_Vendor_Components_Goodneighbor_Daisy. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_15 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to LL_Vendor_Components_Goodneighbor_Daisy. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_15 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to LL_Vendor_Components_Goodneighbor_Daisy. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_15 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to LL_Vendor_Components_Goodneighbor_Daisy. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_15 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to LL_Vendor_Components_Goodneighbor_Daisy. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_15 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to LL_Vendor_Components_Goodneighbor_Daisy. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_15 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to LL_Vendor_Components_Goodneighbor_Daisy. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_15 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to LL_Vendor_Components_Goodneighbor_Daisy. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_15 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Goodneighbor_Daisy. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_15 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL16
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property LL_Vendor_Components_Brotherhood_General Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_16 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_16 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_16 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_16 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_16 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_16 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_16 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_16 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_16 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_16 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_16 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL17
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property LL_Vendor_Components_Goodneighbor_KillorBeKilled Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_17 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to LL_Vendor_Components_Goodneighbor_KillorBeKilled. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_17 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to LL_Vendor_Components_Goodneighbor_KillorBeKilled. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_17 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to LL_Vendor_Components_Goodneighbor_KillorBeKilled. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_17 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to LL_Vendor_Components_Goodneighbor_KillorBeKilled. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_17 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to LL_Vendor_Components_Goodneighbor_KillorBeKilled. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_17 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to LL_Vendor_Components_Goodneighbor_KillorBeKilled. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_17 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to LL_Vendor_Components_Goodneighbor_KillorBeKilled. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_17 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to LL_Vendor_Components_Goodneighbor_KillorBeKilled. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_17 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to LL_Vendor_Components_Goodneighbor_KillorBeKilled. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_17 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Goodneighbor_KillorBeKilled. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_17 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL18
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property LL_Vendor_Components_BunkerHill_Kay Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_18 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to LL_Vendor_Components_BunkerHill_Kay. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_18 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to LL_Vendor_Components_BunkerHill_Kay. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_18 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to LL_Vendor_Components_BunkerHill_Kay. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_18 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to LL_Vendor_Components_BunkerHill_Kay. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_18 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to LL_Vendor_Components_BunkerHill_Kay. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_18 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to LL_Vendor_Components_BunkerHill_Kay. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_18 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to LL_Vendor_Components_BunkerHill_Kay. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_18 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to LL_Vendor_Components_BunkerHill_Kay. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_18 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to LL_Vendor_Components_BunkerHill_Kay. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_18 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_BunkerHill_Kay. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_18 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL19
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property Container_Loot_ToolBox_Large Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_19 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to Container_Loot_ToolBox_Large. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_19 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to Container_Loot_ToolBox_Large. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_19 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to Container_Loot_ToolBox_Large. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_19 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to Container_Loot_ToolBox_Large. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_19 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to Container_Loot_ToolBox_Large. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_19 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to Container_Loot_ToolBox_Large. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_19 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to Container_Loot_ToolBox_Large. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_19 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to Container_Loot_ToolBox_Large. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_19 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to Container_Loot_ToolBox_Large. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_19 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to Container_Loot_ToolBox_Large. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_19 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup

Group VanillaLL20
	{First Vanilla LL to add to. All custom LL from the Alpha-Foxtrot groups will be added to this list.}
		
	LeveledItem Property Container_Loot_Gorebag_Misc Auto Const
	{Choose a Level List to add your LL to.}
	int Property Alpha_PlayerLevel_Vanilla_LL_20 = 0 Auto Const
	{Player level to add GasMask_LOOT_Stockpile_Filters_SML to Container_Loot_Gorebag_Misc. Defaults to what you specified as PlayerLevel in AlphaSettings.}
	int Property Bravo_PlayerLevel_Vanilla_LL_20 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor to Container_Loot_Gorebag_Misc. Defaults to what you specified as PlayerLevel in BravoSettings.}
	int Property Charlie_PlayerLevel_Vanilla_LL_20 = 0 Auto Const
	{Player level to add GasMask_LOOT_Vendor_Filters to Container_Loot_Gorebag_Misc. Defaults to what you specified as PlayerLevel in CharlieSettings.}
	int Property Delta_PlayerLevel_Vanilla_LL_20 = 0 Auto Const
	{Player level to add GasMask_LOOT_Filters to Container_Loot_Gorebag_Misc. Defaults to what you specified as PlayerLevel in DeltaSettings.}	
	int Property Foxtrot_PlayerLevel_Vanilla_LL_20 = 0 Auto Const
	{Player level to add GasMask_LOOT_DirtyFilters to Container_Loot_Gorebag_Misc. Defaults to what you specified as PlayerLevel in FoxtrotSettings.}	
	int Property Alpha_Count_Vanilla_LL_20 = 0 Auto Const
	{Number of GasMask_LOOT_Stockpile_Filters_SML to add to Container_Loot_Gorebag_Misc. Defaults to what you specified as Count in AlphaSettings.}
	int Property Bravo_Count_Vanilla_LL_20 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor to add to Container_Loot_Gorebag_Misc. Defaults to what you specified as Count in BravoSettings.}
	int Property Charlie_Count_Vanilla_LL_20 = 0 Auto Const
	{Number of GasMask_LOOT_Vendor_Filters to add to Container_Loot_Gorebag_Misc. Defaults to what you specified as Count in CharlieSettings.}
	int Property Delta_Count_Vanilla_LL_20 = 0 Auto Const
	{Number of GasMask_LOOT_Filters to add to Container_Loot_Gorebag_Misc. Defaults to what you specified as Count in DeltaSettings.}
	int Property Foxtrot_Count_Vanilla_LL_20 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to Container_Loot_Gorebag_Misc. Defaults to what you specified as Count in FoxtrotSettings.}
	int Property Foxtrot2_Count_Vanilla_LL_20 = 0 Auto Const
	{Number of GasMask_LOOT_DirtyFilters to add to LL_Vendor_Components_Brotherhood_General. Defaults to what you specified as Count in Foxtrot2Settings.}
EndGroup






Function addLLToLL(LeveledItem lst, int custlvl_Alpha, int custlvl_Bravo, int custlvl_Charlie, int custlvl_Delta, int custlvl_Foxtrot, int custcount_Alpha, int custcount_Bravo, int custcount_Charlie, int custcount_Delta, int custcount_Foxtrot, int custcount2_Foxtrot)
	if (GasMask_LOOT_Stockpile_Filters_SML)
		int lvl = Alpha_PlayerLevel
		int count = Alpha_Count
		If custlvl_Alpha != 0
			lvl = custlvl_Alpha
		EndIf
		If custcount_Alpha != 0
			count = custcount_Alpha
		EndIf
		lst.AddForm(GasMask_LOOT_Stockpile_Filters_SML as Form, lvl, count)
	EndIf
	if (GasMask_LOOT_Vendor)
		int lvl = Bravo_PlayerLevel
		int count = Bravo_Count
		If custlvl_Bravo != 0
			lvl = custlvl_Bravo
		EndIf
		If custcount_Bravo != 0
			count = custcount_Bravo
		EndIf
		lst.AddForm(GasMask_LOOT_Vendor as Form, lvl, count)
	EndIf
	if (GasMask_LOOT_Vendor_Filters)
		int lvl = Charlie_PlayerLevel
		int count = Charlie_Count
		If custlvl_Charlie != 0
			lvl = custlvl_Charlie
		EndIf
		If custcount_Charlie != 0
			count = custcount_Charlie
		EndIf
		lst.AddForm(GasMask_LOOT_Vendor_Filters as Form, lvl, count)
	EndIf
	if (GasMask_LOOT_Filters)
		int lvl = Delta_PlayerLevel
		int count = Delta_Count
		If custlvl_Delta != 0
			lvl = custlvl_Delta
		EndIf
		If custcount_Delta != 0
			count = custcount_Delta
		EndIf
		lst.AddForm(GasMask_LOOT_Filters as Form, lvl, count)
	EndIf
	if (GasMask_LOOT_DirtyFilters)
		int lvl = Foxtrot_PlayerLevel
		int count = Foxtrot_Count
		If custlvl_Foxtrot != 0
			lvl = custlvl_Foxtrot
		EndIf
		If custcount_Foxtrot != 0
			count = custcount_Foxtrot
		EndIf
		lst.AddForm(GasMask_LOOT_DirtyFilters as Form, lvl, count)
	EndIf
	if (GasMask_NPC_Military_Random)
		int lvl = Foxtrot_PlayerLevel
		int count = Foxtrot2_Count
		If custlvl_Foxtrot != 0
			lvl = custlvl_Foxtrot
		EndIf
		If custcount2_Foxtrot != 0
			count = custcount2_Foxtrot
		EndIf
		lst.AddForm(GasMask_NPC_Military_Random as Form, lvl, count)
	EndIf
EndFunction

Event OnEnable()
	If Added == false
		WriteLine(Log, "Leveled Lists Added")
		If WorkshopProduceScavenge
			addLLToLL(WorkshopProduceScavenge, Alpha_PlayerLevel_Vanilla_LL_1, Bravo_PlayerLevel_Vanilla_LL_1, Charlie_PlayerLevel_Vanilla_LL_1, Delta_PlayerLevel_Vanilla_LL_1,  Foxtrot_PlayerLevel_Vanilla_LL_1, Alpha_Count_Vanilla_LL_1, Bravo_Count_Vanilla_LL_1, Charlie_Count_Vanilla_LL_1, Delta_Count_Vanilla_LL_1, Foxtrot_Count_Vanilla_LL_1, Foxtrot2_Count_Vanilla_LL_1)
		EndIf
		If Container_Loot_Trashcan
			addLLToLL(Container_Loot_Trashcan, Alpha_PlayerLevel_Vanilla_LL_2, Bravo_PlayerLevel_Vanilla_LL_2, Charlie_PlayerLevel_Vanilla_LL_2, Delta_PlayerLevel_Vanilla_LL_2,  Foxtrot_PlayerLevel_Vanilla_LL_2, Alpha_Count_Vanilla_LL_2, Bravo_Count_Vanilla_LL_2, Charlie_Count_Vanilla_LL_2, Delta_Count_Vanilla_LL_2, Foxtrot_Count_Vanilla_LL_2, Foxtrot2_Count_Vanilla_LL_2)
		EndIf
		If Container_Loot_Cooler_Raider
			addLLToLL(Container_Loot_Cooler_Raider, Alpha_PlayerLevel_Vanilla_LL_3, Bravo_PlayerLevel_Vanilla_LL_3, Charlie_PlayerLevel_Vanilla_LL_3, Delta_PlayerLevel_Vanilla_LL_3,  Foxtrot_PlayerLevel_Vanilla_LL_3, Alpha_Count_Vanilla_LL_3, Bravo_Count_Vanilla_LL_3, Charlie_Count_Vanilla_LL_3, Delta_Count_Vanilla_LL_3, Foxtrot_Count_Vanilla_LL_3, Foxtrot2_Count_Vanilla_LL_3)
		EndIf
		If Container_Loot_DuffleBag_Guns
			addLLToLL(Container_Loot_DuffleBag_Guns, Alpha_PlayerLevel_Vanilla_LL_4, Bravo_PlayerLevel_Vanilla_LL_4, Charlie_PlayerLevel_Vanilla_LL_4, Delta_PlayerLevel_Vanilla_LL_4,  Foxtrot_PlayerLevel_Vanilla_LL_4, Alpha_Count_Vanilla_LL_4, Bravo_Count_Vanilla_LL_4, Charlie_Count_Vanilla_LL_4, Delta_Count_Vanilla_LL_4, Foxtrot_Count_Vanilla_LL_4, Foxtrot2_Count_Vanilla_LL_4)
		EndIf
		If Container_Loot_Medkit_Chems_Raider
			addLLToLL(Container_Loot_Medkit_Chems_Raider, Alpha_PlayerLevel_Vanilla_LL_5, Bravo_PlayerLevel_Vanilla_LL_5, Charlie_PlayerLevel_Vanilla_LL_5, Delta_PlayerLevel_Vanilla_LL_5,  Foxtrot_PlayerLevel_Vanilla_LL_5, Alpha_Count_Vanilla_LL_5, Bravo_Count_Vanilla_LL_5, Charlie_Count_Vanilla_LL_5, Delta_Count_Vanilla_LL_5, Foxtrot_Count_Vanilla_LL_5, Foxtrot2_Count_Vanilla_LL_5)
		EndIf
		If Container_Loot_Suitcase_Armor_Raider
			addLLToLL(Container_Loot_Suitcase_Armor_Raider, Alpha_PlayerLevel_Vanilla_LL_6, Bravo_PlayerLevel_Vanilla_LL_6, Charlie_PlayerLevel_Vanilla_LL_6, Delta_PlayerLevel_Vanilla_LL_6,  Foxtrot_PlayerLevel_Vanilla_LL_6, Alpha_Count_Vanilla_LL_6, Bravo_Count_Vanilla_LL_6, Charlie_Count_Vanilla_LL_6, Delta_Count_Vanilla_LL_6, Foxtrot_Count_Vanilla_LL_6, Foxtrot2_Count_Vanilla_LL_6)
		EndIf
		If Container_Loot_Toolbox_Raider
			addLLToLL(Container_Loot_Toolbox_Raider, Alpha_PlayerLevel_Vanilla_LL_7, Bravo_PlayerLevel_Vanilla_LL_7, Charlie_PlayerLevel_Vanilla_LL_7, Delta_PlayerLevel_Vanilla_LL_7,  Foxtrot_PlayerLevel_Vanilla_LL_7, Alpha_Count_Vanilla_LL_7, Bravo_Count_Vanilla_LL_7, Charlie_Count_Vanilla_LL_7, Delta_Count_Vanilla_LL_7, Foxtrot_Count_Vanilla_LL_7, Foxtrot2_Count_Vanilla_LL_7)
		EndIf
		If Container_Loot_Cabinet_Garage
			addLLToLL(Container_Loot_Cabinet_Garage, Alpha_PlayerLevel_Vanilla_LL_8, Bravo_PlayerLevel_Vanilla_LL_8, Charlie_PlayerLevel_Vanilla_LL_8, Delta_PlayerLevel_Vanilla_LL_8,  Foxtrot_PlayerLevel_Vanilla_LL_8, Alpha_Count_Vanilla_LL_8, Bravo_Count_Vanilla_LL_8, Charlie_Count_Vanilla_LL_8, Delta_Count_Vanilla_LL_8, Foxtrot_Count_Vanilla_LL_8, Foxtrot2_Count_Vanilla_LL_8)
		EndIf
		If VL_Vendor_General
			addLLToLL(VL_Vendor_General, Alpha_PlayerLevel_Vanilla_LL_9, Bravo_PlayerLevel_Vanilla_LL_9, Charlie_PlayerLevel_Vanilla_LL_9, Delta_PlayerLevel_Vanilla_LL_9,  Foxtrot_PlayerLevel_Vanilla_LL_9, Alpha_Count_Vanilla_LL_9, Bravo_Count_Vanilla_LL_9, Charlie_Count_Vanilla_LL_9, Delta_Count_Vanilla_LL_9, Foxtrot_Count_Vanilla_LL_9, Foxtrot2_Count_Vanilla_LL_9)
		EndIf
		If LLI_Vendor_Items_Small_Basic
			addLLToLL(LLI_Vendor_Items_Small_Basic, Alpha_PlayerLevel_Vanilla_LL_10, Bravo_PlayerLevel_Vanilla_LL_10, Charlie_PlayerLevel_Vanilla_LL_10, Delta_PlayerLevel_Vanilla_LL_10,  Foxtrot_PlayerLevel_Vanilla_LL_10, Alpha_Count_Vanilla_LL_10, Bravo_Count_Vanilla_LL_10, Charlie_Count_Vanilla_LL_10, Delta_Count_Vanilla_LL_10, Foxtrot_Count_Vanilla_LL_10, Foxtrot2_Count_Vanilla_LL_10)
		EndIf
		If VL_Vendor_Chems
			addLLToLL(VL_Vendor_Chems, Alpha_PlayerLevel_Vanilla_LL_11, Bravo_PlayerLevel_Vanilla_LL_11, Charlie_PlayerLevel_Vanilla_LL_11, Delta_PlayerLevel_Vanilla_LL_11,  Foxtrot_PlayerLevel_Vanilla_LL_11, Alpha_Count_Vanilla_LL_11, Bravo_Count_Vanilla_LL_11, Charlie_Count_Vanilla_LL_11, Delta_Count_Vanilla_LL_11, Foxtrot_Count_Vanilla_LL_11, Foxtrot2_Count_Vanilla_LL_11)
		EndIf
		If VL_Vendor_Clothing
			addLLToLL(VL_Vendor_Clothing, Alpha_PlayerLevel_Vanilla_LL_12, Bravo_PlayerLevel_Vanilla_LL_12, Charlie_PlayerLevel_Vanilla_LL_12, Delta_PlayerLevel_Vanilla_LL_12,  Foxtrot_PlayerLevel_Vanilla_LL_12, Alpha_Count_Vanilla_LL_12, Bravo_Count_Vanilla_LL_12, Charlie_Count_Vanilla_LL_12, Delta_Count_Vanilla_LL_12, Foxtrot_Count_Vanilla_LL_12, Foxtrot2_Count_Vanilla_LL_12)
		EndIf
		If Container_Loot_WoodCrate_PreWar
			addLLToLL(Container_Loot_WoodCrate_PreWar, Alpha_PlayerLevel_Vanilla_LL_13, Bravo_PlayerLevel_Vanilla_LL_13, Charlie_PlayerLevel_Vanilla_LL_13, Delta_PlayerLevel_Vanilla_LL_13,  Foxtrot_PlayerLevel_Vanilla_LL_13, Alpha_Count_Vanilla_LL_13, Bravo_Count_Vanilla_LL_13, Charlie_Count_Vanilla_LL_13, Delta_Count_Vanilla_LL_13, Foxtrot_Count_Vanilla_LL_13, Foxtrot2_Count_Vanilla_LL_13)
		EndIf
		If Container_Loot_WoodCrate_Raider
			addLLToLL(Container_Loot_WoodCrate_Raider, Alpha_PlayerLevel_Vanilla_LL_14, Bravo_PlayerLevel_Vanilla_LL_14, Charlie_PlayerLevel_Vanilla_LL_14, Delta_PlayerLevel_Vanilla_LL_14,  Foxtrot_PlayerLevel_Vanilla_LL_14, Alpha_Count_Vanilla_LL_14, Bravo_Count_Vanilla_LL_14, Charlie_Count_Vanilla_LL_14, Delta_Count_Vanilla_LL_14, Foxtrot_Count_Vanilla_LL_14, Foxtrot2_Count_Vanilla_LL_14)
		EndIf
		If LL_Vendor_Components_Goodneighbor_Daisy
			addLLToLL(LL_Vendor_Components_Goodneighbor_Daisy, Alpha_PlayerLevel_Vanilla_LL_15, Bravo_PlayerLevel_Vanilla_LL_15, Charlie_PlayerLevel_Vanilla_LL_15, Delta_PlayerLevel_Vanilla_LL_15,  Foxtrot_PlayerLevel_Vanilla_LL_15, Alpha_Count_Vanilla_LL_15, Bravo_Count_Vanilla_LL_15, Charlie_Count_Vanilla_LL_15, Delta_Count_Vanilla_LL_15, Foxtrot_Count_Vanilla_LL_15, Foxtrot2_Count_Vanilla_LL_15)
		EndIf
		If LL_Vendor_Components_Brotherhood_General
			addLLToLL(LL_Vendor_Components_Brotherhood_General, Alpha_PlayerLevel_Vanilla_LL_16, Bravo_PlayerLevel_Vanilla_LL_16, Charlie_PlayerLevel_Vanilla_LL_16, Delta_PlayerLevel_Vanilla_LL_16,  Foxtrot_PlayerLevel_Vanilla_LL_16, Alpha_Count_Vanilla_LL_16, Bravo_Count_Vanilla_LL_16, Charlie_Count_Vanilla_LL_16, Delta_Count_Vanilla_LL_16, Foxtrot_Count_Vanilla_LL_16, Foxtrot2_Count_Vanilla_LL_16)
		EndIf
		If LL_Vendor_Components_Goodneighbor_KillorBeKilled
			addLLToLL(LL_Vendor_Components_Goodneighbor_KillorBeKilled, Alpha_PlayerLevel_Vanilla_LL_17, Bravo_PlayerLevel_Vanilla_LL_17, Charlie_PlayerLevel_Vanilla_LL_17, Delta_PlayerLevel_Vanilla_LL_17,  Foxtrot_PlayerLevel_Vanilla_LL_17, Alpha_Count_Vanilla_LL_17, Bravo_Count_Vanilla_LL_17, Charlie_Count_Vanilla_LL_17, Delta_Count_Vanilla_LL_17, Foxtrot_Count_Vanilla_LL_17, Foxtrot2_Count_Vanilla_LL_17)
		EndIf
		If LL_Vendor_Components_BunkerHill_Kay
			addLLToLL(LL_Vendor_Components_BunkerHill_Kay, Alpha_PlayerLevel_Vanilla_LL_18, Bravo_PlayerLevel_Vanilla_LL_18, Charlie_PlayerLevel_Vanilla_LL_18, Delta_PlayerLevel_Vanilla_LL_18,  Foxtrot_PlayerLevel_Vanilla_LL_18, Alpha_Count_Vanilla_LL_18, Bravo_Count_Vanilla_LL_18, Charlie_Count_Vanilla_LL_18, Delta_Count_Vanilla_LL_18, Foxtrot_Count_Vanilla_LL_18, Foxtrot2_Count_Vanilla_LL_18)
		EndIf
		If Container_Loot_ToolBox_Large
			addLLToLL(Container_Loot_ToolBox_Large, Alpha_PlayerLevel_Vanilla_LL_19, Bravo_PlayerLevel_Vanilla_LL_19, Charlie_PlayerLevel_Vanilla_LL_19, Delta_PlayerLevel_Vanilla_LL_19,  Foxtrot_PlayerLevel_Vanilla_LL_19, Alpha_Count_Vanilla_LL_19, Bravo_Count_Vanilla_LL_19, Charlie_Count_Vanilla_LL_19, Delta_Count_Vanilla_LL_19, Foxtrot_Count_Vanilla_LL_19, Foxtrot2_Count_Vanilla_LL_19)
		EndIf
		If Container_Loot_Gorebag_Misc
			addLLToLL(Container_Loot_Gorebag_Misc, Alpha_PlayerLevel_Vanilla_LL_20, Bravo_PlayerLevel_Vanilla_LL_20, Charlie_PlayerLevel_Vanilla_LL_20, Delta_PlayerLevel_Vanilla_LL_20,  Foxtrot_PlayerLevel_Vanilla_LL_20, Alpha_Count_Vanilla_LL_20, Bravo_Count_Vanilla_LL_20, Charlie_Count_Vanilla_LL_20, Delta_Count_Vanilla_LL_20, Foxtrot_Count_Vanilla_LL_20, Foxtrot2_Count_Vanilla_LL_20)
		EndIf
		Added = true
	EndIf
	
	
EndEvent







