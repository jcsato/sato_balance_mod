::mods_hookNewObject("skills/actives/bandage_ally_skill", function(bas) {
	local getTooltip		= bas.getTooltip;
	local onUse				= bas.onUse;

	bas.m.Description = "Save yourself or another character from bleeding to death by applying pressure and provisional bandaging to any such wound. Does not heal hitpoints. Using it on a character makes them temporarily vulnerable to melee and ranged attacks.";

	bas.getTooltip = function() {
		local ret = getTooltip();

		// Remove "engaged in melee" warning from tooltip, if necessary
		if (Tactical.isActive() && getContainer().getActor().getTile().hasZoneOfControlOtherThan(getContainer().getActor().getAlliedFactions()))
			ret.pop();

		return ret;
	}

	bas.isUsable = function() {
		if (!Tactical.isActive())
			return false;

		// local actor = getContainer().getActor();
		// local wounded = actor.getSkills().hasSkill("effects.bleeding") || actor.getSkills().hasSkill("injury.cut_artery") || actor.getSkills().hasSkill("injury.cut_throat") || actor.getSkills().hasSkill("injury.grazed_neck");

		// local tile = actor.getTile();
		return skill.isUsable();// && (wounded || !tile.hasZoneOfControlOtherThan(getContainer().getActor().getAlliedFactions()));
	}

	bas.onVerifyTarget = function(_originTile, _targetTile) {
		if (!skill.onVerifyTarget(_originTile, _targetTile))
			return false;

		local target = _targetTile.getEntity();

		if (!m.Container.getActor().isAlliedWith(target))
			return false;

		// if (_targetTile.getEntity() != _originTile.getEntity() && _targetTile.hasZoneOfControlOtherThan(m.Container.getActor().getAlliedFactions()))
		// 	return false;

		if (target.getSkills().hasSkill("effects.bleeding"))
			return true;

		local skill;

		skill = target.getSkills().getSkillByID("injury.cut_artery");
		if (skill != null && skill.isFresh())
			return true;

		skill = target.getSkills().getSkillByID("injury.cut_throat");
		if (skill != null && skill.isFresh())
			return true;

		skill = target.getSkills().getSkillByID("injury.grazed_neck");
		if (skill != null && skill.isFresh())
			return true;

		return false;
	}

	bas.onUse = function(_user, _targetTile) {
		onUse(_user, _targetTile);

		local target = _targetTile.getEntity();
		_user.getSkills().add(new("scripts/skills/effects/vulnerable_effect"));
		target.getSkills().add(new("scripts/skills/effects/vulnerable_effect"));

		return true;
	}
});

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
