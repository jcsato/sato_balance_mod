::mods_queue("sato_balance_mod", "", function() {
	::Const.Strings.PerkDescription.SpecSword = "Master the art of swordfighting and using your opponent's mistakes to your advantage. Skills build up [color=" + Const.UI.Color.NegativeValue + "]25%[/color] less Fatigue.\n\nRiposte gives [color=" + Const.UI.Color.PositiveValue + "]+5[/color] Melee Defense with the offhand free.\n\nGash has a [color=" + Const.UI.Color.NegativeValue + "]50%[/color] lower threshold to inflict injuries.\n\nSplit and Swing no longer have a penalty to hitchance and gain [color=" + Const.UI.Color.PositiveValue + "]+5%[/color] chance to hit.";
	local perk = ::Const.Perks.Perks[3][5];
	if (perk.ID == "perk.mastery.sword")
		perk.Tooltip = ::Const.Strings.PerkDescription.SpecSword;

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
});
