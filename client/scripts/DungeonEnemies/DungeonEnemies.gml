function Enemy(_status, _idle_spr, _walking_spr, _init_state, _movement, _actions, _battle_script) constructor {
	status = _status;
	idle_spr = _idle_spr;
	walking_spr = _walking_spr;
	init_state = _init_state;
	movement = _movement;
	actions = _actions;
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
		new Status(10, 3, 5, 2, 0, 2, 0),
		spr_slime_idle,
		spr_slime_idle,
		enemy_chase_idle,
		6,
		[global.actions.attack],
		global.enemy_ui.simple
	));
}
