
::mods_hookExactClass("entity/tactical/skeleton", function(s) {

	local onDeath = ::mods_getMember(s, "onDeath");
	local generateCorpse = ::mods_getMember(s, "generateCorpse");

	::mods_override(s, "onDeath", function(_killer, _skill, _tile, _fatalityType) {
		if (_skill.getID() == "effects.holy_water")
			m.IsResurrectable = false;

		onDeath(_killer, _skill, _tile, _fatalityType);
	});

	::mods_override(s, "generateCorpse", function(_tile, _fatalityType, _killer) {
		local corpse = generateCorpse(_tile, _fatalityType, _killer);

		return corpse;
	});
});

::mods_hookExactClass("entity/tactical/enemies/zombie", function(z) {
	::mods_addField(z, "zombie", "IsResurrectable", true);

	local onDeath = ::mods_getMember(z, "onDeath");
	local generateCorpse = ::mods_getMember(z, "generateCorpse");

	::mods_override(z, "onDeath", function(_killer, _skill, _tile, _fatalityType) {
		if (_skill.getID() == "effects.holy_water")
			m.IsResurrectable = false;

		onDeath(_killer, _skill, _tile, _fatalityType);
	});

	::mods_override(z, "generateCorpse", function(_tile, _fatalityType, _killer) {
		local fatality = _fatalityType;

		// This hack is necessary to prevent zombies from setting up auto resurrection within generateCorpse
		if (!m.IsResurrectable) {
			m.IsResurrectingOnFatality = false;
			fatality = Const.FatalityType.Smashed;
		}

		return generateCorpse(_tile, fatality, _killer);
	});
});
