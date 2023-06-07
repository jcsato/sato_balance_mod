::mods_hookBaseClass("items/helmets/helmet", function(h) {
	local create = ::mods_getMember(h, "create");

	h.create = function()
	{
		create();
		if (m.ID == "armor.head.gladiator_helmet") {
			m.Condition = Math.min(m.Condition, 220);
			m.ConditionMax = 220;
			m.StaminaModifier = -12;
		}
	}
});
