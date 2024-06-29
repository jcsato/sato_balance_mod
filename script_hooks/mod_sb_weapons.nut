::mods_hookBaseClass("items/weapons/weapon", function(w) {
	local create = ::mods_getMember(w, "create");

	w.create = function() {
		create();
		if (m.ID == "weapon.handgonne") {
			m.RegularDamage = 40;    	// Default 35
			m.RegularDamageMax = 70; 	// Default 75
		} else if (m.ID == "weapon.woodcutters_axe") {
			m.RegularDamage = 50;		// Default 35
			m.RegularDamageMax = 75;	// Default 70
		} else if (m.ID == "weapon.greatsword") {
			m.RegularDamageMax = 105;	// Default 100
			m.DirectDamageMult = 0.3;	// Default 0.25
		} else if (m.ID == "weapon.heavy_rusty_axe") {
			m.RegularDamage = 70;		// Default 75
		} else if (m.ID == "weapon.javelin" || m.ID == "weapon.heavy_javelin" || m.ID == "weapon.orc_javelin") {
			m.Ammo -= 2;
			m.AmmoMax -= 2;
		} else if (m.ID == "weapon.throwing_axe" || m.ID == "weapon.heavy_throwing_axe") {
			m.Ammo -= 1;
			m.AmmoMax -= 1;
		} else if (m.ID == "weapon.wonky_bow" || m.ID == "weapon.short_bow" || m.ID == "weapon.hunting_bow"
					|| m.ID == "weapon.composite_bow" || m.ID == "weapon.war_bow" || m.ID == "weapon.masterwork_bow"
					|| m.ID == "weapon.goblin_bow" || m.ID == "weapon.goblin_heavy_bow") {
			m.ArmorDamageMult += 0.05;
		}

		if (m.ID == "weapon.goblin_falchion" || m.ID == "weapon.goblin_notched_blade" || m.ID == "weapon.goblin_spear"
			|| m.ID == "weapon.goblin_bow" || m.ID == "weapon.goblin_heavy_bow" || m.ID == "weapon.goblin_spiked_balls") {
			m.FatigueOnSkillUse += -3;
		}
	}
});

::mods_hookExactClass("skills/actives/ignite_firelance_skill", function(ifs) {
	local getTooltip			= ::mods_getMember(ifs, "getTooltip");
	local applyEffectToTargets	= ::mods_getMember(ifs, "applyEffectToTargets");

	::mods_override(ifs, "getTooltip", function() {
		local ret = getTooltip();

		ret.insert(ret.len() - 1, { id = 6, type = "text", icon = "ui/icons/special.png", text = "Set [color=" + Const.UI.Color.DamageValue + "]2[/color] tiles in the direction of the attack ablaze with fire for 2 rounds. Water and snow can not burn." } );
		ret.insert(ret.len() - 1, { id = 6, type = "text", icon = "ui/icons/special.png", text = "Burns away existing tile effects like Smoke or Miasma" } );

		return ret;
	});

	::mods_override(ifs, "applyEffectToTargets", function(_tag) {
		// First, recalculate which tiles should be affected
		// This needs to happen before calling `applyEffectToTargets` in case _tag.Targets[0] is dead
		local targetTile = _tag.Targets[0].getTile();
		local dir = _tag.User.getTile().getDirectionTo(targetTile)
		local tiles = [ targetTile ];

		if (targetTile.hasNextTile(dir)) {
			local nextTile = targetTile.getNextTile(dir);

			if (Math.abs(nextTile.Level - _tag.User.getTile().Level) <= 1)
				tiles.push(nextTile);
		}

		applyEffectToTargets(_tag);

		local fireEffect = {
			Type					= "fire"
			Tooltip					= "Fire rages here, melting armor and flesh alike"
			IsPositive				= false
			IsAppliedAtRoundStart	= false
			IsAppliedAtTurnEnd		= true
			IsAppliedOnMovement		= false
			IsAppliedOnEnter		= false
			IsByPlayer				= _tag.User.isPlayerControlled()
			Timeout					= Time.getRound() + 2
			Callback				= Const.Tactical.Common.onApplyFire
			Applicable				= function(_a) { return true; }
		};

		foreach (tile in tiles) {
			if (tile.Subtype != Const.Tactical.TerrainSubtype.Snow && tile.Subtype != Const.Tactical.TerrainSubtype.LightSnow && tile.Type != Const.Tactical.TerrainType.ShallowWater && tile.Type != Const.Tactical.TerrainType.DeepWater) {
				if (tile.Properties.Effect != null && tile.Properties.Effect.Type == "fire") {
					tile.Properties.Effect.Timeout = Time.getRound() + 2;
				} else {
					if (tile.Properties.Effect != null)
						Tactical.Entities.removeTileEffect(tile);

					tile.Properties.Effect = clone fireEffect;

					local particles = [];
					for (local i = 0; i < Const.Tactical.FireParticles.len(); ++i) {
						particles.push(Tactical.spawnParticleEffect(true, Const.Tactical.FireParticles[i].Brushes, tile, Const.Tactical.FireParticles[i].Delay, Const.Tactical.FireParticles[i].Quantity, Const.Tactical.FireParticles[i].LifeTimeQuantity, Const.Tactical.FireParticles[i].SpawnRate, Const.Tactical.FireParticles[i].Stages));
					}

					Tactical.Entities.addTileEffect(tile, tile.Properties.Effect, particles);

					tile.clear(Const.Tactical.DetailFlag.Scorchmark);
					tile.spawnDetail("impact_decal", Const.Tactical.DetailFlag.Scorchmark, false, true);
				}
			}
		}
	});
});

::mods_hookExactClass("items/weapons/named/named_goblin_falchion", function(ngf) {
	local randomizeValues = ::mods_getMember(ngf, "randomizeValues");

	::mods_override(ngf, "randomizeValues", function() {
		m.FatigueOnSkillUse += -3;
		randomizeValues();
	});
});

::mods_hookExactClass("items/weapons/named/named_goblin_spear", function(ngs) {
	local randomizeValues = ::mods_getMember(ngs, "randomizeValues");

	::mods_override(ngs, "randomizeValues", function() {
		m.FatigueOnSkillUse += -3;
		randomizeValues();
	});
});

::mods_hookExactClass("items/weapons/named/named_goblin_heavy_bow", function(nghb) {
	local randomizeValues = ::mods_getMember(nghb, "randomizeValues");

	::mods_override(nghb, "randomizeValues", function() {
		m.ArmorDamageMult += 0.05;
		m.FatigueOnSkillUse += -3;
		randomizeValues();
	});
});

::mods_hookExactClass("items/weapons/named/named_warbow", function(nw) {
	local randomizeValues = ::mods_getMember(nw, "randomizeValues");

	::mods_override(nw, "randomizeValues", function() {
		m.ArmorDamageMult += 0.05;
		randomizeValues();
	});
});

::mods_hookExactClass("items/weapons/named/named_javelin", function(nj) {
	local randomizeValues = ::mods_getMember(nj, "randomizeValues");

	::mods_override(nj, "randomizeValues", function() {
		randomizeValues();
		m.Ammo -= 2;
		m.AmmoMax -= 2;
	});
});

::mods_hookExactClass("items/weapons/named/named_throwing_axe", function(nta) {
	local randomizeValues = ::mods_getMember(nta, "randomizeValues");

	::mods_override(nta, "randomizeValues", function() {
		randomizeValues();
		m.Ammo -= 1;
		m.AmmoMax -= 1;
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
