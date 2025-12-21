::mods_hookExactClass("skills/traits/brute_trait", function(bt) {
	local getTooltip = ::mods_getMember(bt, "getTooltip");

	::mods_override(bt, "getTooltip", function() {
		local ret = getTooltip();

		ret.pop();
		ret.pop();

		ret.extend([
			{ id = 10, type = "text", icon = "ui/icons/chance_to_hit_head.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+30%[/color] damage on a hit to the head" }
			{ id = 11, type = "text", icon = "ui/icons/melee_skill.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-5[/color] Melee Skill" }
		]);

		return ret;
	});

	::mods_override(bt, "onAnySkillUsed", function(_skill, _targetEntity, _properties) {
		if (_skill.isAttack() && !_skill.isRanged())
			_properties.DamageAgainstMult[Const.BodyPart.Head] += 0.3;
	});
});

::mods_hookExactClass("skills/traits/cocky_trait", function(ct) {
	local getTooltip = ::mods_getMember(ct, "getTooltip");

	::mods_override(ct, "getTooltip", function() {
		local ret = getTooltip();

		ret.pop();
		ret.pop();
		ret.pop();

		ret.extend([
			{ id = 10, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+10[/color] Resolve" }
			{ id = 11, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-5[/color] Melee Defense" }
			{ id = 12, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-5[/color] Ranged Defense" }
		]);

		return ret;
	});

	::mods_override(ct, "onUpdate", function(_properties) {
		_properties.Bravery			+= 10;
		_properties.MeleeDefense	+= -5;
		_properties.RangedDefense	+= -5;
	});
});

::mods_hookExactClass("skills/traits/tiny_trait", function(tt) {
	local getTooltip = ::mods_getMember(tt, "getTooltip");

	::mods_override(tt, "getTooltip", function() {
		local ret = getTooltip();

		ret.pop();
		ret.pop();
		ret.pop();

		ret.extend([
			{ id = 10, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+5[/color] Melee Defense" }
			{ id = 11, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+5[/color] Ranged Defense" }
			{ id = 12, type = "text", icon = "ui/icons/regular_damage.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-10%[/color] Melee Damage" }
		]);

		return ret;
	});

	::mods_override(tt, "onUpdate", function(_properties) {
		_properties.MeleeDamageMult		*= 0.9;
		_properties.MeleeDefense		+= 5;
		_properties.RangedDefense		+= 5;
	});
});

::mods_hookExactClass("skills/traits/weasel_trait", function(wt) {
	local getTooltip = ::mods_getMember(wt, "getTooltip");
	local onBeingAttacked = ::mods_getMember(wt, "onBeingAttacked");

	::mods_override(wt, "getTooltip", function() {
		local ret = getTooltip();

		ret.pop();

		ret.extend([ { id = 10, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+20[/color] Melee Defense while retreating or fleeing" } ]);

		return ret;
	});

	::mods_override(wt, "onBeingAttacked", function(_attacker, _skill, _properties) {
		if (("State" in Tactical) && Tactical.State != null && Tactical.State.isScenarioMode())
			return;

		local actor = getContainer().getActor();

		if (actor.isPlacedOnMap() && (Tactical.State.isAutoRetreat() || actor.getMoraleState() == Const.MoraleState.Fleeing) && Tactical.TurnSequenceBar.getActiveEntity() != null && Tactical.TurnSequenceBar.getActiveEntity().getID() == actor.getID())
			_properties.MeleeDefense += 20;
	});
});

::mods_hookExactClass("skills/traits/fear_beasts_trait", function(fbt) {
	local getTooltip = ::mods_getMember(fbt, "getTooltip");
	local onCombatStarted = ::mods_getMember(fbt, "onCombatStarted");

	::mods_override(fbt, "getTooltip", function() {
		local ret = getTooltip();

		ret.extend([ { id = 10, type = "text", icon = "ui/icons/morale.png", text = "Will start combat against beasts at wavering morale" } ]);

		return ret;
	});

	::mods_override(fbt, "onCombatStarted", function() {
		onCombatStarted();

		::SB.Helpers.fearHateCombatStart(this, ::SB.Helpers.isBeast, ::SB.Helpers.makeWavering);
	});
});

::mods_hookExactClass("skills/traits/fear_greenskins_trait", function(fgt) {
	local getTooltip = ::mods_getMember(fgt, "getTooltip");
	local onCombatStarted = ::mods_getMember(fgt, "onCombatStarted");

	::mods_override(fgt, "getTooltip", function() {
		local ret = getTooltip();

		ret.extend([ { id = 10, type = "text", icon = "ui/icons/morale.png", text = "Will start combat against greenskins at wavering morale" } ]);

		return ret;
	});

	::mods_override(fgt, "onCombatStarted", function() {
		onCombatStarted();

		::SB.Helpers.fearHateCombatStart(this, ::SB.Helpers.isGreenskin, ::SB.Helpers.makeWavering);
	});
});

::mods_hookExactClass("skills/traits/fear_undead_trait", function(fut) {
	local getTooltip = ::mods_getMember(fut, "getTooltip");
	local onCombatStarted = ::mods_getMember(fut, "onCombatStarted");

	::mods_override(fut, "getTooltip", function() {
		local ret = getTooltip();

		ret.extend([ { id = 10, type = "text", icon = "ui/icons/morale.png", text = "Will start combat against undead at wavering morale" } ]);

		return ret;
	});

	::mods_override(fut, "onCombatStarted", function() {
		onCombatStarted();

		::SB.Helpers.fearHateCombatStart(this, ::SB.Helpers.isUndead, ::SB.Helpers.makeWavering);
	});
});

::mods_hookExactClass("skills/traits/hate_beasts_trait", function(hbt) {
	local getTooltip = ::mods_getMember(hbt, "getTooltip");
	local onCombatStarted = ::mods_getMember(hbt, "onCombatStarted");

	::mods_override(hbt, "getTooltip", function() {
		local ret = getTooltip();

		ret.extend([ { id = 10, type = "text", icon = "ui/icons/morale.png", text = "Will start combat against beasts at confident morale if permitted by mood" } ]);

		return ret;
	});

	::mods_override(hbt, "onCombatStarted", function() {
		onCombatStarted();

		::SB.Helpers.fearHateCombatStart(this, ::SB.Helpers.isBeast, ::SB.Helpers.makeConfident);
	});
});

::mods_hookExactClass("skills/traits/hate_greenskins_trait", function(hgt) {
	local getTooltip = ::mods_getMember(hgt, "getTooltip");
	local onCombatStarted = ::mods_getMember(hgt, "onCombatStarted");

	::mods_override(hgt, "getTooltip", function() {
		local ret = getTooltip();

		ret.extend([ { id = 10, type = "text", icon = "ui/icons/morale.png", text = "Will start combat against greenskins at confident morale if permitted by mood" } ]);

		return ret;
	});

	::mods_override(hgt, "onCombatStarted", function() {
		onCombatStarted();

		::SB.Helpers.fearHateCombatStart(this, ::SB.Helpers.isGreenskin, ::SB.Helpers.makeConfident);
	});
});

::mods_hookExactClass("skills/traits/hate_undead_trait", function(hut) {
	local getTooltip = ::mods_getMember(hut, "getTooltip");
	local onCombatStarted = ::mods_getMember(hut, "onCombatStarted");

	::mods_override(hut, "getTooltip", function() {
		local ret = getTooltip();

		ret.extend([ { id = 10, type = "text", icon = "ui/icons/morale.png", text = "Will start combat against undead at confident morale if permitted by mood" } ]);

		return ret;
	});

	::mods_override(hut, "onCombatStarted", function() {
		onCombatStarted();

		::SB.Helpers.fearHateCombatStart(this, ::SB.Helpers.isUndead, ::SB.Helpers.makeConfident);
	});
});
