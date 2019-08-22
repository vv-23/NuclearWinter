Scriptname NuclearWinter:Player:AilmentRecovery extends ActiveMagicEffect
import NuclearWinter

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	If Thermodynamics.CoreTemperature >= 89.6
		If Game.GetPlayer().HasPerk(akPerk)
			;akSpell.Cast(Game.GetPlayer(), Game.GetPlayer())
			;Game.GetPlayer().RemovePerk(akPerk)
			;akMessage.Show()
		EndIf
	EndIf
EndEvent

World:Thermodynamics Property Thermodynamics Auto Const Mandatory
Spell Property akSpell Auto
{Spell to Dispel ailment effects}
Perk Property akPerk Auto
{Ailment Perk}
Message Property akMessage Auto
{Ailment Recovery Message}
