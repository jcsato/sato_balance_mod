::mods_registerMod("sato_balance_mod", 1.5, "Sato's Balance Mod");

::mods_queue("sato_balance_mod", null, function() {
	::include("script_hooks/mod_sb_armor");
	::include("script_hooks/mod_sb_named_weapons");
	::include("script_hooks/mod_sb_perks");
	::include("script_hooks/mod_sb_recovery_items");
	::include("script_hooks/mod_sb_retinue");
	::include("script_hooks/mod_sb_traits");
	::include("script_hooks/mod_sb_tryout");
	::include("script_hooks/mod_sb_warwolf");
	::include("script_hooks/mod_sb_weapons");
});
