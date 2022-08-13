::mods_queue("sato_balance_mod", "", function() {
    ::mods_hookExactClass("entity/tactical/player", function(p) {
        local onHired = ::mods_getMember(p, "onHired");

        ::mods_override(p, "onHired", function() {
            onHired();

            if (m.IsTryoutDone) {
                improveMood(0.5, "Was scrutinized and still hired");
                getSkills().add(new("scripts/skills/effects_world/tryout_effect"));
            }
        });
    });
});
