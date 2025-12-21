::SB.Helpers <- {
	fearHateCombatStart = function(trait, isEnemyRelevant, adjustMorale) {
		local actor = trait.getContainer().getActor();

		if (!actor.isPlacedOnMap())
			return;

		local relevantEnemy = false;
		local enemies = Tactical.Entities.getAllHostilesAsArray();

		foreach (enemy in enemies) {
			if (isEnemyRelevant(enemy)) {
				relevantEnemy = true;
				break;
			}
		}

		if (relevantEnemy) {
			// Trim `ui/traits/` and `.png`
			local iconName = trait.getIconColored().slice(10, -4);
			local spawnIconCallback = function(_tag) { _tag.Skill.spawnIcon(_tag.Icon, _tag.Actor.getTile()); };

			// Delay icon spawning to make it happen when the player can actually view the tactical map
			Time.scheduleEvent(TimeUnit.Virtual, ::SB.CombatStartIconDelay, spawnIconCallback, { Actor = actor, Skill = trait, Icon = iconName });

			adjustMorale(actor);
		}
	}

	isBeast = function(enemy) {
		return (
			Const.EntityType.getDefaultFaction(enemy.getType()) == Const.FactionType.Beasts
			|| enemy.getType() == Const.EntityType.BarbarianUnhold
			|| enemy.getType() == Const.EntityType.BarbarianUnholdFrost
		);
	}

	isGreenskin = function(enemy) {
		return (
			Const.EntityType.getDefaultFaction(enemy.getType()) == Const.FactionType.Orcs || Const.EntityType.getDefaultFaction(enemy.getType()) == Const.FactionType.Goblins
		);
	}

	isUndead = function(enemy) {
		return (
			Const.EntityType.getDefaultFaction(enemy.getType()) == Const.FactionType.Zombies
			|| Const.EntityType.getDefaultFaction(enemy.getType()) == Const.FactionType.Undead
		);
	}

	makeWavering = function(actor) {
		if (actor.getMoraleState() > Const.MoraleState.Wavering)
			actor.setMoraleState(Const.MoraleState.Wavering);
	}

	makeConfident = function(actor) {
		if (actor.getMoodState() >= Const.MoodState.Neutral && actor.getMoraleState() < Const.MoraleState.Confident)
			actor.setMoraleState(Const.MoraleState.Confident);
	}
};
