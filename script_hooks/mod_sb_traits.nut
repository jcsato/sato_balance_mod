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

		ret.extend([
			{ id = 10, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Melee Defense while retreating or fleeing" }
		]);

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
