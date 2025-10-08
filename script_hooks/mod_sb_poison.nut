::mods_hookExactClass("entity/tactical/actor", function(a) {
	local onAfterInit = ::mods_getMember(a, "onAfterInit");

	::mods_override(a, "onAfterInit", function() {
		onAfterInit();

		m.Skills.add(new("scripts/skills/special/poison_application"));
	});
});

::mods_hookExactClass("skills/effects/poison_coat_effect", function(pce) {
	::mods_addField(pce, "poison_cost_effect", "AttacksLeft", 6);		// Default 4

	local resetTime = ::mods_getMember(pce, "resetTime");

	::mods_override(pce, "resetTime", function() {
		resetTime();

		m.AttacksLeft = 6;
	});
});

::mods_hookExactClass("skills/effects/spider_poison_coat_effect", function(spce) {
	::mods_addField(spce, "spider_poison_cost_effect", "AttacksLeft", 6);		// Default 4

	local resetTime = ::mods_getMember(spce, "resetTime");

	::mods_override(spce, "resetTime", function() {
		resetTime();

		m.AttacksLeft = 6;
	});
});
