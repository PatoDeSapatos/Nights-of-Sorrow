enum MOVE_TYPES {
	SLASHING,
	BLUDGEONING,
	PIERCING,
	FIRE,
	LIGHT,
	POISON
}

enum MOVE_SHAPES {
	CIRCLE,
	SQUARE
}

enum CONDITIONS {
	NEVER,
	ONLY,
	ALWAYS
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
		prioritizeEnemies: true,
		targetCount: 1,
		targetSelf: false,
		range: 1,
		
		func: function(_user, _targets) {
			var _user_attack = unit_get_stats(_user, "attack");
			
			var _damage = ceil(_user_attack + random_range(-_user_attack * .25, _user_attack * .25));
			var _types = _user.unit.attack_types;
			
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
		targetCount: 1,
		targetSelf: false,
		prioritizeEnemies: true,
		charge: true,
		chargingTurns: 3,
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
	},
	fireBall: {
		name: "Fire Ball",
		description: "Casts a powerfull fireball that give damage to a area.",
		targetRequired: true,
		targetCount: -1,
		targetSelf: true,
		prioritizeEnemies: true,
		charge: false,
		range: 6,
		projectile: spr_fire_ball_projectile,
		onUserEffect: spr_effect_fire_ball_casting,
		landingSpr: spr_effect_fire_ball_landing,
		areaTarget: true,
		originInPlayer: false,
		shape: MOVE_SHAPES.CIRCLE,
		shapeSize: 3,
		
		func: function (_user, _targets) {
			for (var i = 0; i < array_length(_targets); ++i) {
				var _attack = unit_get_stats(_user, "magic_attack");
				var _damage = ceil(_attack*2.5 + irandom(_attack));
			    unit_take_damage(_damage, _user, _targets[i], [MOVE_TYPES.FIRE], false);
			}
		}
	},
	poisonMist: {
		name: "Poison Mist",
		description: "Spreads a poison mist around the caster that gives damage and has a chance to poison.",
		targetRequired: true,
		targetCount: -1,
		targetSelf: false,
		prioritizeEnemies: true,
		charge: false,
		range: 3,
		areaTarget: true,
		originInPlayer: true,
		shape: MOVE_SHAPES.CIRCLE,
		
		func: function (_user, _targets) {
			for (var i = 0; i < array_length(_targets); ++i) {
				var _attack = unit_get_stats(_user, "magic_attack");
				var _damage = ceil(_attack + irandom(_attack div 4));
			    unit_take_damage(_damage, _user, _targets[i], [MOVE_TYPES.POISON], false);
				battle_inflict_condition(_targets[i], global.conditions.poison, 33);
			}
		}
	}
	
}