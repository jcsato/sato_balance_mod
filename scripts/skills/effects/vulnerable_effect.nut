vulnerable_effect <- inherit("scripts/skills/skill", {
	m = {
		Count			= 1
		DefenseMalus	= 4
		TurnsLeft		= 1
	}

	function create() {
		m.ID					= "effects.vulnerable";
		m.Name					= "Vulnerable";
		m.Icon					= "ui/perks/perk_55.png";
		m.IconMini				= "perk_55_mini";
		m.Overlay				= "perk_55";
		m.Type					= Const.SkillType.StatusEffect;
		m.IsActive				= false;
		m.IsStacking			= false;
		m.IsRemovedAfterBattle	= true;
	}

	function getDescription() {
		return "This character directed his focus away from combat to treat a wound. Vulnerable for [color=" + Const.UI.Color.NegativeValue + "]" + m.TurnsLeft + "[/color] more round(s), their defensive abilities are comprised and they make an easier target than normal.";
	}

	function getTooltip() {
		return [
					{ id = 1, type = "title", text = getName() }
					{ id = 2, type = "description", text = getDescription() }
					{ id = 10, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.DefenseMalus * m.Count + "[/color] Melee Defense" }
					{ id = 11, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-" + m.DefenseMalus * m.Count + "[/color] Ranged Defense" }
				];
	}

	function getName() {
		if (m.Count <= 1)
			return m.Name;
		else
			return m.Name + " (x" + m.Count + ")";
	}

	function onAdded() {
		m.TurnsLeft = Math.max(1, 1 + getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
	}

	function onRefresh() {
		m.TurnsLeft = Math.max(1, 1 + getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
		++m.Count;
		getContainer().update();
	}

	function onUpdate(_properties) {
		_properties.MeleeDefense	-= m.DefenseMalus * m.Count;
		_properties.RangedDefense	-= m.DefenseMalus * m.Count;
	}

	function onRoundEnd() {
		if (--m.TurnsLeft <= 0)
			removeSelf();
	}
});
