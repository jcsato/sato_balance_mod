::mods_queue("sato_balance_mod", "", function() {
	::mods_hookExactClass("items/weapons/named/named_weapon", function(nw) {
		local randomizeValues = ::mods_getMember(nw, "randomizeValues");

		local newRandomizeValues = function() {
			if (m.ConditionMax > 1) {
				m.Condition = Math.round(m.Condition * Math.rand(90, 140) * 0.01) * 1.0;
				m.ConditionMax = m.Condition;
			}

			local available = [];
			available.push(function ( _i ) {
				local f = Math.rand(110, 130) * 0.01;
				_i.m.RegularDamage = Math.round(_i.m.RegularDamage * f);
				_i.m.RegularDamageMax = Math.round(_i.m.RegularDamageMax * f);
			});
			available.push(function ( _i ) {
				_i.m.ArmorDamageMult = _i.m.ArmorDamageMult + Math.rand(15, 35) * 0.01;
			});

			if (m.ChanceToHitHead > 0) {
				available.push(function ( _i ) {
					_i.m.ChanceToHitHead = _i.m.ChanceToHitHead + Math.rand(10, 20);
				});
			}

			available.push(function ( _i ) {
				_i.m.DirectDamageAdd = _i.m.DirectDamageAdd + Math.rand(6, 12) * 0.01;
			});

			// if (m.StaminaModifier <= -10) {
			// 	available.push(function ( _i ) {
			// 		_i.m.StaminaModifier = Math.round(_i.m.StaminaModifier * Math.rand(50, 80) * 0.01);
			// 	});
			// }

			if (m.ShieldDamage >= 16) {
				available.push(function ( _i ) {
					_i.m.ShieldDamage = Math.round(_i.m.ShieldDamage * Math.rand(150, 200) * 0.01);
				});
			}

			if (m.AmmoMax > 0) {
				available.push(function ( _i ) {
					_i.m.AmmoMax = _i.m.AmmoMax + Math.rand(1, 3);
					_i.m.Ammo = _i.m.AmmoMax;
				});
			}

			if (m.AdditionalAccuracy != 0 || isItemType(Const.Items.ItemType.RangedWeapon)) {
				available.push(function ( _i ) {
					_i.m.AdditionalAccuracy = _i.m.AdditionalAccuracy + Math.rand(5, 15);
				});
			}

			available.push(function ( _i ) {
				_i.m.FatigueOnSkillUse = _i.m.FatigueOnSkillUse - Math.rand(1, 3);
			});

			for( local n = 2; n != 0 && available.len() != 0; n = --n ) {
				local r = Math.rand(0, available.len() - 1);
				available[r](this);
				available.remove(r);
			}
		}

		::mods_override(nw, "randomizeValues", newRandomizeValues);
	});
});
