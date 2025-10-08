::mods_hookChildren("skills/backgrounds/character_background", function(cb) {
	local onChangeAttributes = ::mods_getMember(cb, "onChangeAttributes");

	::mods_override(cb, "onChangeAttributes", function() {
		local change = onChangeAttributes();

		// Increase all bro's baseline Fatigue by +5 and Ranged Skill by +3
		change.Stamina[0] += 5;
		change.Stamina[1] += 5;

		change.RangedSkill[0] += 3;
		change.RangedSkill[1] += 3;

		// Lower Ranged Skill increase to +1 for Hunters and +2 for Ranged Nomads
		if (m.ID == "background.hunter") {
			change.RangedSkill[0] -= 2;
			change.RangedSkill[1] -= 2;
		} else if (m.ID == "background.nomad" && change.RangedSkill[0] > 10) {
			change.RangedSkill[0] -= 1;
			change.RangedSkill[1] -= 1;
		}

		return change;
	});
});
