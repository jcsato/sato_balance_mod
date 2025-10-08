poison_application <- inherit("scripts/skills/skill", {
	m = {
		SkillsToAdjust	= ["actives.coat_with_poison", "actives.coat_with_spider_poison"]
		APAdjust		= -3
		FatigueAdjust	= -5
	}

	function create() {
		m.ID					= "special.poison_application";
		m.Name					= "";
		m.Icon					= "";
		m.IconMini				= "";
		m.Overlay				= "";
		m.Type					= Const.SkillType.Special;
		m.Order					= Const.SkillOrder.Last;
		m.IsActive				= false;
		m.IsHidden				= true;
		m.IsSerialized			= false;
	}

	function onUpdate(_properties) {
		foreach(skill in m.SkillsToAdjust)
			_properties.SkillCostAdjustments.push({ ID = skill, APAdjust = m.APAdjust, FatigueAdjust = m.FatigueAdjust, FatigueMultAdjust = 1.0 });
	}
});
