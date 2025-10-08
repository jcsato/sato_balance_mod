::mods_hookNewObject("skills/actives/drink_antidote_skill", function(das) {
	local getTooltip	= das.getTooltip;

	das.getTooltip = function() {
		local ret = getTooltip();

		local isEngaged = Tactical.isActive() && getContainer().getActor().getTile().hasZoneOfControlOtherThan(getContainer().getActor().getAlliedFactions());

		ret.pop();
		ret.pop();

		ret.push( { id = 8, type = "text", icon = "ui/icons/special.png", text = "Grants immunity to Poison for 10 turns" } );
		if (isEngaged)
			ret.push( { id = 5, type = "text", icon = "ui/tooltips/warning.png", text = "[color=" + Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]" } );

		return ret;
	}
});

::mods_hookNewObject("skills/effects/antidote_effect", function(ae) {
	ae.onAdded = function() {
		m.TurnsLeft = 10;
	}

	ae.onRefresh = function() {
		m.TurnsLeft = 10;
	}
});
