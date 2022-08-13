tryout_effect <- inherit("scripts/skills/injury/injury", {
	m = {
		XPGainMult = 1.1
	}

	function create() {
		injury.create();

		m.ID = "effects.tryout";
		m.Name = "Tried out";
		m.Description = "This character was recently vetted by experienced mercenaries, and picked up some tips on how to improve their own skills in the process.";
		m.Icon = "skills/status_effect_73.png";

		m.Type = m.Type | Const.SkillType.StatusEffect;
		m.IsHealingMentioned = false;
		m.IsTreatable = false;
		m.IsContentWithReserve = false;

		m.HealingTimeMin = 2;
		m.HealingTimeMax = 2;
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() },
			{ id = 2, type = "description", text = getDescription() },
			{ id = 13, type = "text", icon = "ui/icons/xp_received.png", text = "[color=" + Const.UI.Color.PositiveValue + "]+" + (m.XPGainMult * 100 - 100) + "%[/color] Experience Gain" }
		];
		addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties ) {
		injury.onUpdate(_properties);

		_properties.XPGainMult *= m.XPGainMult;
	}
});
