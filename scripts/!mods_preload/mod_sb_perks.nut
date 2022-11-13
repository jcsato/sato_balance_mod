::mods_queue("sato_balance_mod", "", function() {
	::Const.Strings.PerkDescription.SpecSword = "Master the art of swordfighting and using your opponent's mistakes to your advantage. Skills build up [color=" + Const.UI.Color.NegativeValue + "]25%[/color] less Fatigue.\n\nRiposte gives [color=" + Const.UI.Color.PositiveValue + "]+5[/color] Melee Defense with the offhand free.\n\nGash has a [color=" + Const.UI.Color.NegativeValue + "]50%[/color] lower threshold to inflict injuries.\n\nSplit and Swing no longer have a penalty to hitchance and gain [color=" + Const.UI.Color.PositiveValue + "]+5%[/color] chance to hit.";
	local perk = ::Const.Perks.Perks[3][5];
	if (perk.ID == "perk.mastery.sword")
		perk.Tooltip = ::Const.Strings.PerkDescription.SpecSword;

	::Const.Strings.PerkDescription.LoneWolf = "I work best alone. With no ally within 2 tiles of distance, gain a [color=" + Const.UI.Color.PositiveValue + "]10%[/color] bonus to Melee Skill, Ranged Skill, Melee Defense, Ranged Defense, and Resolve.";
	local perk = ::Const.Perks.Perks[4][2];
	if (perk.ID == "perk.lone_wolf")
		perk.Tooltip = ::Const.Strings.PerkDescription.LoneWolf;

	::mods_hookExactClass("skills/actives/riposte", function(r) {
		local getTooltip = ::mods_getMember(r, "getTooltip");

		::mods_override(r, "getTooltip", function() {
			local ret = getTooltip();

			local actor = getContainer().getActor();

			if (actor.getCurrentProperties().IsSpecializedInSwords)
				ret.push({ id = 5, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+5[/color] Melee Defense when the offhand is free" });

			return ret;
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
		});
	});

	::mods_hookExactClass("skills/actives/taunt", function(t) {
		::mods_addField(t, "taunt", "FatigueCost", 10);
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
});
