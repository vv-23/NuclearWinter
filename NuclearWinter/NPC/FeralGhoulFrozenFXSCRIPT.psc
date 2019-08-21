Scriptname NuclearWinter:NPC:FeralGhoulFrozenFXSCRIPT extends ActiveMagicEffect
{FX for Frozen one }

;Armor Property SkinFeralGhoulGlowingGlow Auto
EffectShader Property CryoDamageFXS Auto Const
Spell Property FrozenOneDisintegrationSpell Auto Const
Explosion Property CryoMineExplosion Auto Const

bool isAlive = true
int sleepState =2
int sitState =2
int loop

Event OnEffectStart(Actor akTarget, Actor akCaster)
	;wait while 3d loads
	if  (akCaster as objectReference).WaitFor3DLoad()
		;test to see if xx is in ambush mode
	
		sleepState = akCaster.GetSleepState()
		sitState = akCaster.GetSitState()
		if (sleepState == 3)
			;Low glow in ambushes...set to 1.0 if you decide you want no glow
			akCaster.SetSubGraphFloatVariable("fToggleBlend", 0.75)
		elseif (sitState == 3)
			;no glow
			akCaster.SetSubGraphFloatVariable("fToggleBlend", 0.75)
		else
			;glow
			CryoDamageFXS.Play(akCaster)
			akCaster.SetSubGraphFloatVariable("fToggleBlend", 0.0)
		endIf
	else
		;nothing
	endif
EndEvent

	Event OnGetUp(ObjectReference akFurniture)
		actor selfRef = self.GetTargetActor()
		;debug.trace("WAAAAAAKKEEEEEEEEEE")
		;glow
		CryoDamageFXS.Play(selfRef)
		selfRef.SetSubGraphFloatVariable("fToggleBlend", 0.0)
	endEvent

Event OnCripple(ActorValue akActorValue, bool abCrippled)
	actor selfRef = self.GetTargetActor()
	;Debug.Trace("OnCripple Received: " + akActorValue + ", " + abCrippled)
	if isAlive ==true
		;med glow
		selfRef.SetSubGraphFloatVariable("fToggleBlend", 0.15)
	endIf
EndEvent

Event OnDying(Actor akKiller)
	actor selfRef = self.GetTargetActor()
	isAlive = false
	CryoDamageFXS.stop(selfRef)
	ObjectReference CryoExplosion = selfRef.PlaceAtMe(CryoMineExplosion, 1)
	FrozenOneDisintegrationSpell.Cast(selfRef, selfRef)
	selfRef.SetSubGraphFloatVariable("fDampRate", 0.005)
    selfRef.SetSubGraphFloatVariable("fToggleBlend", 0.35)
EndEvent

Event OnDeath(Actor akKiller)
	actor selfRef = self.GetTargetActor()
	isAlive = false
    selfRef.SetSubGraphFloatVariable("fToggleBlend", 0.35)
	selfRef.setAlpha(0.0)
EndEvent
