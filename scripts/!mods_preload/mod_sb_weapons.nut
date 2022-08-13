::mods_queue("sato_balance_mod", "", function() {
	::mods_hookBaseClass("items/weapons/weapon", function(w) {
		local create = ::mods_getMember(w, "create");

		w.create = function()
		{
			create();
			if (m.ID == "weapon.handgonne") {
				m.RegularDamage = 40;    	// Default 35
				m.RegularDamageMax = 70; 	// Default 75
			} else if (m.ID == "weapon.greatsword") {
				m.RegularDamageMax = 105;	// Default 100
				m.DirectDamageMult = 0.3;	// Default 0.25
			} else if (m.ID == "weapon.heavy_rusty_axe") {
				m.RegularDamage = 70;		// Default 75
			} else if (m.ID == "weapon.javelin" || m.ID == "weapon.heavy_javelin" || m.ID == "weapon.orc_javelin") {
				m.Ammo -= 2;
				m.AmmoMax -= 2;
			}
		}
	});

	::mods_hookExactClass("items/weapons/named/named_javelin", function(nj) {
		local randomizeValues = ::mods_getMember(nj, "randomizeValues");

		::mods_override(nj, "randomizeValues", function() {
			randomizeValues();
			m.Ammo -= 2;
			m.AmmoMax -= 2;
		});
	});

	::mods_hookExactClass("items/weapons/named/named_handgonne", function(nh) {
		local randomizeValues = ::mods_getMember(nh, "randomizeValues");

		::mods_override(nh, "randomizeValues", function() {
			m.RegularDamage = 40;
			m.RegularDamageMax = 70;
			randomizeValues();
		});
	});

	::mods_hookExactClass("items/weapons/named/named_heavy_rusty_axe", function(nh) {
		local randomizeValues = ::mods_getMember(nh, "randomizeValues");

		::mods_override(nh, "randomizeValues", function() {
			m.RegularDamage = 70;
			randomizeValues();
		});
	});

	::mods_hookExactClass("items/weapons/named/named_greatsword", function(nh) {
		local randomizeValues = ::mods_getMember(nh, "randomizeValues");

		::mods_override(nh, "randomizeValues", function() {
			m.RegularDamageMax = 105;
			m.DirectDamageMult = 0.3;
			randomizeValues();
		});
	});

	::mods_hookNewObject("skills/actives/overhead_strike", function(os) {
		::mods_addField(os, "overhead_strike", "DirectDamageMult", 0.3);
	});

	::mods_hookNewObject("skills/actives/split", function(s) {
		::mods_addField(s, "split", "DirectDamageMult", 0.35);
	});

	::mods_hookNewObject("skills/actives/swing", function(s) {
		::mods_addField(s, "swing", "DirectDamageMult", 0.3);
	});

	::mods_hookNewObject("skills/actives/aimed_shot", function(as) {
		::mods_addField(as, "aimed_shot", "AdditionalAimedAccuracy", 15);
		::mods_addField(as, "aimed_shot", "AdditionalAimedDamage", 0.15);

		::mods_override(as, "getTooltip", function() {
			local ret = getDefaultTooltip();

			ret.extend([
				{ id = 6, type = "text", icon = "ui/icons/vision.png", text = "Has a range of [color=" + Const.UI.Color.PositiveValue + "]" + getMaxRange() + "[/color] tiles on even ground, more if shooting downhill" }				
			]);

			if (m.AdditionalAimedAccuracy + m.AdditionalAccuracy >= 0)
				ret.push( { id = 7, type = "text", icon = "ui/icons/hitchance.png", text = "Has [color=" + Const.UI.Color.PositiveValue + "]+" + (m.AdditionalAimedAccuracy + m.AdditionalAccuracy) + "%[/color] chance to hit, and [color=" + Const.UI.Color.NegativeValue + "]" + (-2 + m.AdditionalHitChance) + "%[/color] per tile of distance" } );
			else
				ret.push( { id = 7, type = "text", icon = "ui/icons/hitchance.png", text = "Has [color=" + Const.UI.Color.NegativeValue + "]" + (m.AdditionalAimedAccuracy + m.AdditionalAccuracy) + "%[/color] chance to hit, and [color=" + Const.UI.Color.NegativeValue + "]" + (-2 + m.AdditionalHitChance) + "%[/color] per tile of distance" } );

			local ammo = getAmmo();
			if (ammo > 0)
				ret.push( { id = 8, type = "text", icon = "ui/icons/ammo.png", text = "Has [color=" + Const.UI.Color.PositiveValue + "]" + ammo + "[/color] arrows left" } );
			else
				ret.push( { id = 8, type = "text", icon = "ui/tooltips/warning.png", text = "[color=" + Const.UI.Color.NegativeValue + "]Needs a non-empty quiver of arrows equipped[/color]" } );

			if (Tactical.isActive() && getContainer().getActor().getTile().hasZoneOfControlOtherThan(getContainer().getActor().getAlliedFactions()))
				ret.push( { id = 9, type = "text", icon = "ui/tooltips/warning.png", text = "[color=" + Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]" } );

			return ret;
		});

		::mods_override(as, "onAnySkillUsed", function(_skill, _targetEntity, _properties) {
			if (_skill == this) {
				_properties.RangedSkill						+= m.AdditionalAimedAccuracy + m.AdditionalAccuracy;
				_properties.HitChanceAdditionalWithEachTile += -2 + m.AdditionalHitChance;
				_properties.DamageRegularMult				*= (1.0 + m.AdditionalAimedDamage);

				if(_properties.IsSharpshooter)
					_properties.DamageDirectMult += 0.05;
			}
		});
	});

	::mods_hookNewObject("skills/actives/lunge_skill", function(ls) {
		::mods_override(ls, "onAnySkillUsed", function(_skill, _targetEntity, _properties) {
			if (_skill == this) {
				local a = getContainer().getActor();
				local s = Math.maxf(1.0, Math.minf(2.0, 2.0 * (Math.max(0, a.getInitiative() + (_targetEntity != null ? getFatigueCost() * a.getCurrentProperties().FatigueToInitiativeRate : 0)) / 160.0)));

				_properties.DamageTotalMult		*= s;
			}
		});
	});
});
