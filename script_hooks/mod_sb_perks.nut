::Const.Strings.PerkDescription.SpecSword = "Master the art of swordfighting and using your opponent's mistakes to your advantage. Skills build up [color=" + Const.UI.Color.NegativeValue + "]25%[/color] less Fatigue.\n\nRiposte gives [color=" + Const.UI.Color.PositiveValue + "]+5[/color] Melee Defense with the offhand free.\n\nGash has a [color=" + Const.UI.Color.NegativeValue + "]50%[/color] lower threshold to inflict injuries.\n\nSplit and Swing no longer have a penalty to hitchance and gain [color=" + Const.UI.Color.PositiveValue + "]+5%[/color] chance to hit.";
local perk = ::Const.Perks.Perks[3][5];
if (perk.ID == "perk.mastery.sword")
	perk.Tooltip = ::Const.Strings.PerkDescription.SpecSword;

::Const.Strings.PerkDescription.SpecDagger = "Master swift and deadly daggers. Skills build up [color=" + Const.UI.Color.NegativeValue + "]25%[/color] less Fatigue.\n\nStab, Puncture and Deathblow have a reduced Action Point cost to allow for an additional attack each turn.\n\nPuncture gains [color=" + Const.UI.Color.PositiveValue + "]+5%[/color] chance to hit.";
local perk = ::Const.Perks.Perks[3][6];
if (perk.ID == "perk.mastery.dagger")
	perk.Tooltip = ::Const.Strings.PerkDescription.SpecDagger;

::Const.Strings.PerkDescription.LoneWolf = "I work best alone. With no ally within 2 tiles of distance, gain a [color=" + Const.UI.Color.PositiveValue + "]10%[/color] bonus to Melee Skill, Ranged Skill, Melee Defense, Ranged Defense, and Resolve.";
local perk = ::Const.Perks.Perks[4][2];
if (perk.ID == "perk.lone_wolf")
	perk.Tooltip = ::Const.Strings.PerkDescription.LoneWolf;

::Const.Strings.PerkDescription.Nimble = "Specialize in light armor! By nimbly dodging or deflecting blows, reduce hitpoint damage taken by up to [color=" + Const.UI.Color.PositiveValue + "]60%[/color]. The reduction is lowered by the total Maximum Fatigue penalty from body and head armor above [color=" + Const.UI.Color.PositiveValue + "]15[/color], and halved for blows struck against unarmored body parts.\n\nBrawny does not affect this perk.\n\nDoes not affect damage from mental attacks or status effects, but can help to avoid receiving them.";
local perk = ::Const.Perks.Perks[5][2];
if (perk.ID == "perk.nimble")
	perk.Tooltip = ::Const.Strings.PerkDescription.Nimble;

::mods_hookExactClass("skills/actives/riposte", function(r) {
	local getTooltip = ::mods_getMember(r, "getTooltip");

	::mods_override(r, "getTooltip", function() {
		local ret = getTooltip();

		// Remove old hitchance message
		// ret.pop();
		// ret.push({ id = 4, type = "text", icon = "ui/icons/hitchance.png", text = "Has [color=" + Const.UI.Color.NegativeValue + "]-5%[/color] chance to hit" });

		local actor = getContainer().getActor();

		if (actor.getCurrentProperties().IsSpecializedInSwords) {
			ret.push({ id = 4, type = "text", icon = "ui/icons/hitchance.png", text = "Has [color=" + Const.UI.Color.NegativeValue + "]-10%[/color] chance to hit" });
			ret.push({ id = 5, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+5[/color] Melee Defense when the offhand is free" });
		}

		return ret;
	});
});

::mods_hookExactClass("skills/actives/puncture", function(p) {
	local getTooltip = ::mods_getMember(p, "getTooltip");
	local onAnySkillUsed = ::mods_getMember(p, "onAnySkillUsed");

	::mods_override(p, "getTooltip", function() {
		local ret = getTooltip();
		local newRet = getDefaultTooltip();

		local actor = getContainer().getActor();

		if (actor.getCurrentProperties().IsSpecializedInDaggers) {
			newRet.push({ id = 7, type = "text", icon = "ui/icons/hitchance.png", text = "Has [color=" + Const.UI.Color.NegativeValue + "]-10%[/color] chance to hit" });
			newRet.extend(ret.slice(newRet.len()))
		} else {
			newRet = clone ret;
		}

		return newRet;
	});

	::mods_override(p, "onAnySkillUsed", function(_skill, _targetEntity, _properties) {
		onAnySkillUsed(_skill, _targetEntity, _properties);

		if (_skill == this && getContainer().getActor().getCurrentProperties().IsSpecializedInDaggers)
			_properties.MeleeSkill	+= 5;
	});
});

::mods_hookExactClass("skills/effects/riposte_effect", function(re) {
	local getTooltip = ::mods_getMember(re, "getTooltip");
	local onUpdate = ::mods_getMember(re, "onUpdate");

	::mods_override(re, "getTooltip", function() {
		local ret = getTooltip();
		local actor = getContainer().getActor();

		if (actor.getCurrentProperties().IsSpecializedInSwords && (actor.getItems().getItemAtSlot(Const.ItemSlot.Offhand) == null && !actor.getItems().hasBlockedSlot(Const.ItemSlot.Offhand)))
			ret.push({ id = 5, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+5[/color] Melee Defense because the offhand is free" });

		return ret;
	});

	::mods_override(re, "onUpdate", function(_properties) {
		onUpdate(_properties);

		local actor = getContainer().getActor();

		if (actor.getCurrentProperties().IsSpecializedInSwords && (actor.getItems().getItemAtSlot(Const.ItemSlot.Offhand) == null && !actor.getItems().hasBlockedSlot(Const.ItemSlot.Offhand)))
			_properties.MeleeDefense += 5;
	})

	::mods_override(re, "onAnySkillUsed", function(_skill, _targetEntity, _properties) {
		if ((Tactical.TurnSequenceBar.getActiveEntity() == null || Tactical.TurnSequenceBar.getActiveEntity().getID() != getContainer().getActor().getID()))
			_properties.MeleeSkill	-= 10;
			// _properties.MeleeSkill	-= 5;
	});
});

::mods_hookNewObject("skills/actives/taunt", function(t) {
	// ::mods_addField(t, "taunt", "ActionPointCost", 4);
	::mods_addField(t, "taunt", "FatigueCost", 12);		// Default 15
});

::mods_hookNewObject("skills/actives/rotation", function(r) {
	::mods_addField(r, "rotation", "FatigueCost", 20);	// Default 25
});

::mods_hookNewObject("skills/actives/footwork", function(f) {
	::mods_addField(f, "footwork", "FatigueCost", 18);	// Default 20
});

::mods_hookExactClass("skills/effects/lone_wolf_effect", function(lwe) {
	local getTooltip = ::mods_getMember(lwe, "getTooltip");
	local onUpdate = ::mods_getMember(lwe, "onUpdate");

	::mods_override(lwe, "getTooltip", function() {
		return [
				{ id = 1, type = "title", text = getName() }
				{ id = 2, type = "description", text = getDescription() }
				{ id = 10, type = "text", icon = "ui/icons/melee_skill.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+10%[/color] Melee Skill" }
				{ id = 11, type = "text", icon = "ui/icons/ranged_skill.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+10%[/color] Ranged Skill" }
				{ id = 12, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+10%[/color] Melee Defense" }
				{ id = 13, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+10%[/color] Ranged Defense" }
				{ id = 14, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+10%[/color] Resolve" }
			];
	});

	::mods_override(lwe, "onUpdate", function(_properties) {
		if (!getContainer().getActor().isPlacedOnMap()) {
			m.IsHidden = true;
			return;
		}

		local actor = getContainer().getActor();
		local myTile = actor.getTile();
		local allies = Tactical.Entities.getInstancesOfFaction(actor.getFaction());
		local isAlone = true;

		foreach (ally in allies) {
			if (ally.getID() == actor.getID() || !ally.isPlacedOnMap())
				continue;

			if (ally.getTile().getDistanceTo(myTile) <= 2) {
				isAlone = false;
				break;
			}
		}

		if (isAlone) {
			m.IsHidden = false;
			_properties.MeleeSkillMult		*= 1.1;
			_properties.RangedSkillMult		*= 1.1;
			_properties.MeleeDefenseMult	*= 1.1;
			_properties.RangedDefenseMult	*= 1.1;
			_properties.BraveryMult			*= 1.1;
		}
		else
			m.IsHidden = true;
	});
});

::mods_hookExactClass("skills/perks/perk_nimble", function(pn) {
	local getTooltip = ::mods_getMember(pn, "getTooltip");

	::mods_override(pn, "getTooltip", function() {
		local ret = getTooltip();
		local fm = Math.round((getChance()) * 100);

		if (fm < 100)
			ret.push({ id = 7, type = "text", icon = "ui/icons/warning.png", text = "Damage reduction is halved for blows stuck against unarmored body parts" });

		return ret;
	});

	::mods_override(pn, "onBeforeDamageReceived", function(_attacker, _skill, _hitInfo, _properties) {
		local actor = getContainer().getActor();
		if ((_attacker != null && _attacker.getID() == getContainer().getActor().getID()) || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
			return;

		local reduction = getChance();

		if (actor.getArmor(_hitInfo.BodyPart) == 0 && _hitInfo.DamageInflictedArmor == 0)
			reduction = reduction + Math.maxf(0, (1.0 - reduction) / 2);

		_properties.DamageReceivedRegularMult *= reduction;
	});
});
