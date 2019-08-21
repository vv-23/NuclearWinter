ScriptName NuclearWinter:Gear:InsulationWidgetToggle extends ActiveMagicEffect

NuclearWinter:GUI:InsulationWidget Property InsulationWidget Auto Const Mandatory
Potion Property Winter_InsulationToggle Auto

Event OnEffectStart(Actor akCaster, Actor akTarget)
	InsulationWidget.ShowWidget()
	Game.GetPlayer().AddItem(Winter_InsulationToggle, 1, true)
EndEvent
