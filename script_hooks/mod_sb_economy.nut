::mods_hookExactClass("entity/tactical/player", function(p) {
	local getDailyCost = ::mods_getMember(p, "getDailyCost");
	local getRosterTooltip = ::mods_getMember(p, "getRosterTooltip");

	::mods_addMember(p, "player", "getDailyCostPreview", function() {
		return getDailyCost();
	});

	::mods_override(p, "getDailyCost", function() {
		// Check this directly instead of using `getDaysWithCompany` because we want a float to avoid skipping pay for
		// starting bros on day 2
		local dayWithCompany = Math.round((Time.getVirtualTimeF() - m.HireTime) / World.getTime().SecondsPerDay);

		if (getDaysWithCompany() < 1.0)
			return 0;

		return getDailyCost();
	});

	::mods_override(p, "getRosterTooltip", function() {
		local tooltip = getRosterTooltip();

		if (isGuest())
			return tooltip;

		if (getDailyCost != 0)
			tooltip.remove(3);

		if (getDailyCostPreview() != 0)
			tooltip.insert(3, { id = 3, type = "text", icon = "ui/icons/asset_daily_money.png", text = "Paid [img]gfx/ui/tooltips/money.png[/img]" + getDailyCostPreview() + " daily" })

		return tooltip;
	});
});

::mods_hookNewObject("states/world/asset_manager", function(am) {
	local getDailyMoneyCost = ::mods_getMember(am, "getDailyMoneyCost");

	::mods_override(am, "getDailyMoneyCost", function() {
		local roster = World.getPlayerRoster().getAll();

		return roster.map(@(bro) bro.getDailyCostPreview()).reduce(@(cost, broCost) cost + broCost);
	});
});
