::mods_queue("sato_balance_mod", "", function() {
	::mods_hookExactClass("skills/traits/brute_trait", function(bt) {
		local getTooltip = ::mods_getMember(bt, "getTooltip");

		::mods_override(bt, "getTooltip", function() {
			local ret = getTooltip();

			ret.pop();
			ret.pop();

			ret.extend([
				{ id = 10, type = "text", icon = "ui/icons/chance_to_hit_head.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+35%[/color] Damage on a hit to the head" }
				{ id = 11, type = "text", icon = "ui/icons/melee_skill.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-5[/color] Melee Skill" }
			]);

			return ret;
		});

		::mods_override(bt, "onAnySkillUsed", function(_skill, _targetEntity, _properties) {
			if (_skill.isAttack() && !_skill.isRanged())
				_properties.DamageAgainstMult[Const.BodyPart.Head] += 0.35;
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
});
