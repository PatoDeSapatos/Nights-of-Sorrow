function Enemy(_display_name, _stats, _idle_spr, _walking_spr, _attack_spr, _hurt_spr, _init_state, _movement, _actions, _attack_types, _weakness, _resistences, _battle_script) constructor {
	display_name = _display_name;
	stats = _stats;
	sprites = {
		idle: _idle_spr,
		walking: _walking_spr,
		attack: _attack_spr,
		hurt: _hurt_spr
	}
	init_state = _init_state;
	movement = _movement;
	actions = _actions;
	attack_types = _attack_types;
	weakness = _weakness;
	resistences = _resistences;
	battle_script = _battle_script;
}

function get_enemy(_id) {
	if ( ds_map_exists(global.enemies, _id) ) {
		return ds_map_find_value(global.enemies, _id);
	}
	
	return undefined;
}

function instantiate_enemy(_x, _y, _id) {
	var _enemy = get_enemy(_id);
	
	if (!is_undefined(_enemy)) {
        
		instance_create_layer(_x, _y, "Instances", obj_dungeon_enemy, {
			dungeon_stats: _enemy
		});
	}
}

function init_enemies() {
	// Slime
	ds_map_add(global.enemies, "SLIME", new Enemy(
		"Slime",
		new Stats(10, 3, 5, 2, 0, 2, 0),
		spr_slime_idle,
		spr_slime_idle,
		spr_slime_attack,
		spr_slime_hurt,
		enemy_chase_idle,
		6,
		[global.actions.attack],
		[MOVE_TYPES.BLUDGEONING],
		[MOVE_TYPES.FIRE],
		[MOVE_TYPES.SLASHING],
		global.enemy_ui.simple
	));
}
