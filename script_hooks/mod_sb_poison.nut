::mods_hookExactClass("entity/tactical/actor", function(a) {
	local onAfterInit = ::mods_getMember(a, "onAfterInit");

	::mods_override(a, "onAfterInit", function() {
		onAfterInit();

		m.Skills.add(new("scripts/skills/special/poison_application"));
	});
});

::mods_hookExactClass("skills/effects/poison_coat_effect", function(pce) {
	::mods_addField(pce, "poison_cost_effect", "AttacksLeft", ::SB.PoisonAttackCount);			// Default 4

	local resetTime = ::mods_getMember(pce, "resetTime");

	::mods_override(pce, "resetTime", function() {
		resetTime();

		m.AttacksLeft = ::SB.PoisonAttackCount;
	});
});

::mods_hookExactClass("skills/actives/coat_with_poison_skill", function(cwps) {
	local getTooltip = ::mods_getMember(cwps, "getTooltip");

	::mods_override(cwps, "getTooltip", function() {
		local tooltipContents = getTooltip();

		tooltipContents.insert(3, { id = 7, type = "text", icon = "ui/icons/special.png", text = "The next [color=" + Const.UI.Color.PositiveValue + "]" + ::SB.PoisonAttackCount + "[/color] attacks will apply the Poisoned status effect."});
		tooltipContents.remove(4);

		return tooltipContents;
	});
});

::mods_hookExactClass("skills/effects/spider_poison_coat_effect", function(spce) {
	::mods_addField(spce, "spider_poison_cost_effect", "AttacksLeft", ::SB.PoisonAttackCount);	// Default 4

	local resetTime = ::mods_getMember(spce, "resetTime");

	::mods_override(spce, "resetTime", function() {
		resetTime();

		m.AttacksLeft = ::SB.PoisonAttackCount;
	});
});

::mods_hookExactClass("skills/actives/coat_with_spider_poison_skill", function(cwsps) {
	local getTooltip = ::mods_getMember(cwsps, "getTooltip");

	::mods_override(cwsps, "getTooltip", function() {
		local tooltipContents = getTooltip();

		tooltipContents.insert(3, { id = 7, type = "text", icon = "ui/icons/special.png", text = "The next [color=" + Const.UI.Color.PositiveValue + "]" + ::SB.PoisonAttackCount + "[/color] attacks will apply the Poisoned status effect for [color=" + Const.UI.Color.NegativeValue + "]" + ::SB.PoisonDamagePerTurn + "[/color] damage per turn."});
		tooltipContents.remove(4);

		return tooltipContents;
	});
});
