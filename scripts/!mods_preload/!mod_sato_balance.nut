::mods_registerMod("sato_balance_mod", 2.3.1, "Sato's Balance Mod");

::mods_queue("sato_balance_mod", null, function() {
	::include("script_hooks/!sb_constants");
	::include("script_hooks/!sb_helpers");
	::include("script_hooks/mod_sb_character_stats");
	::include("script_hooks/mod_sb_economy");
	::include("script_hooks/mod_sb_equipment");
	::include("script_hooks/mod_sb_holy_water");
	::include("script_hooks/mod_sb_named_weapons");
	::include("script_hooks/mod_sb_perks");
	::include("script_hooks/mod_sb_poison");
	::include("script_hooks/mod_sb_recovery_items");
	::include("script_hooks/mod_sb_retinue");
	::include("script_hooks/mod_sb_traits");
	::include("script_hooks/mod_sb_warwolf");
	::include("script_hooks/mod_sb_weapons");
});
