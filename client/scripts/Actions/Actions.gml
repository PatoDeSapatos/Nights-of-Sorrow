enum MOVE_TYPES {
	SLASHING,
	BLUDGEONING,
	PIERCING,
	FIRE,
	LIGHT
}

function end_charging_action(_user) {
	with (_user) {
		charging_turns = 0;
		charging_action = noone;
		charging_targets = noone;
	}
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
			var _user_attack = unit_get_stats(_user, "attack");
			
			var _damage = ceil(_user_attack + random_range(-_user_attack * .25, _user_attack * .25));
			var _types = _user.unit.attack_types;
			
			if(is_struct(_targets[0].unit.sprites) && !is_undefined(_targets[0].unit.sprites[$ "hurt"]) ) {
				var _cutscene = [cutscene_animate_once, _targets[0], _targets[0].unit.sprites.hurt];
				instance_create_depth(0, 0, -1000, obj_cutscene, {
					cutscene: [_cutscene, _cutscene]
				});
			}
			
			unit_take_damage(_damage, _user, _targets[0], _types, true);
		}	
	},
	attackBoost: {
		name: "Attack Boost",
		description: "Strongly raises the user attack stat.",
		userAnimation: "idle",
		hit_effect: noone,
		targetRequired: false,
		range: -1,
		
		func: function (_user) {
			battle_change_stats(_user, "attack", 2);
		}
	},
	useItem: {
		name: "Use Item",
		description: "Use a item from your inventory.",
		targetRequired: false,
		range: -1,
		
		func: function (_user, _item_stack) {
			var _item_info = get_item_by_id(_item_stack.id);
			_item_info.battle_script(_user);
		}
	},
	lightRay: {
		name: "Light Ray",
		description: "Charges for three turns, heals on the second and blasts a powerful bean into a enemy.",
		targetRequired: true,
		range: 8,
		
		func: function (_user, _targets) {
			with(_user) { 
				switch(_user.charging_turns) {
					case 0:
						charging_action = global.actions.lightRay;
						charging_turns++;
						break;
					case 1: 
						battle_change_hp(_user, ceil(_user.unit.stats.hp/16));
						charging_turns++;
						break;
					case 2:
						var _attack = unit_get_stats(_user, "magic_attack");
						var _damage = ceil(_attack * 1.5 + irandom(_attack/4));
					
						unit_take_damage(_damage, _user, _targets[0], MOVE_TYPES.LIGHT, false);
						end_charging_action(self);
						break;
				}
			
			}
 		}
	}
	
}