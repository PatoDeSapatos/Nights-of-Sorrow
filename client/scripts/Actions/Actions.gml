enum MOVE_TYPES {
	SLASHING,
	BLUDGEONING,
	PIERCING,
	FIRE
}

global.actions = {
	attack: {
		name: "attack",
		description: "a melee attack!",
		userAnimation: "attack",
		hit_effect: spr_effect_hit,
		targetRequired: true,
		range: 1,
		
		func: function(_user, _targets) {
			var _damage = ceil(_user.unit.status.attack + random_range(-_user.unit.status.attack * .25, _user.unit.status.attack * .25));
			var _types = _user.unit.attack_types;
			
			if(is_struct(_targets[0].unit.sprites) && !is_undefined(_targets[0].unit.sprites[$ "hurt"]) ) {
				var _cutscene = [cutscene_animate_once, _targets[0], _targets[0].unit.sprites.hurt];
				instance_create_depth(0, 0, -1000, obj_cutscene, {
					cutscene: [_cutscene, _cutscene]
				});
			}
			
			unit_take_damage(_damage, _targets[0], _types, true);
		}	
	}
	
}