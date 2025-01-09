function battle_start_state_attack() {
	inventory = instance_create_depth(0, 0, -1000, obj_skill_inventory);
	inventory.skills = [global.actions.attack, global.actions.fireBall, global.actions.attackBoost, global.actions.lightRay, global.actions.poisonMist];
	camera_set_x_buffer(5, .5);
	camera_zoom(10, true);
	state = battle_state_attack;
}

function battle_state_attack() {
	if (instance_exists(inventory)) {
		var _action = inventory.skills[inventory.selected_item];
	
		if (is_struct(_action) && (confirm_input || l_click)) {
			instance_destroy(inventory);
			camera_reset_buffer();
			set_state_targeting(_action);
		}
	}
	
	if (cancel_input) {
		instance_destroy(inventory);
		camera_reset_buffer();
		state = prev_state;
	}
}

function battle_state_item() {
	
	if (cancel_input) {
		state = prev_state;
	}
}

function battle_start_state_move() {
	var _user = extra_action ? extra_turn_user : units[turns];
	movement_tile.x = _user.unit.position.x;
	movement_tile.y = _user.unit.position.y;
	
	target_indicator = instance_create_depth(0, 0, -1000, obj_target_indicator);
	target_indicator.target = movement_tile;
	
	targeted_tiles = [];
	var _lenght = array_length(obj_battle_manager.grid);
	var _movement = units[turns].unit.movement;
	var _player_x = units[turns].unit.position.x;
	var _player_y = units[turns].unit.position.y;
			
	for (var _yy = -(_movement+1); _yy < _movement+1; ++_yy) {
		for (var _xx = -(_movement+1); _xx < _movement+1; ++_xx) {
			var _new_x = _player_x + _xx;
			var _new_y = _player_y + _yy;
					
			if (abs(_xx) + abs(_yy) <= _movement) {
				if((_new_x < 0 || _new_x >= _lenght) || (_new_y < 0 || _new_y >= _lenght)) continue;
				array_push(targeted_tiles, [_new_x, _new_y]);
			}
		}
	}
	
	state = battle_state_move;
}

function battle_state_move() {
	// Movement player
	if (movement_actions <= 0) state = battle_end_state_move;
	
	if (!animating) {
		if (using_mouse && unit_hover == noone && mouse_hover.x != -1 && mouse_hover.y != -1) {
			// Path
			movement_tile.x = mouse_hover.x;
			movement_tile.y = mouse_hover.y;
		}
		
		var _user = extra_action ? extra_turn_user : units[turns];
		var _range = _user.unit.movement;
		
		var _hmov = right_input - left_input;
		var _vmov = down_input - up_input;
		
		if (_hmov != 0 || _vmov != 0) {
			var _in_mov_range = false;
			for (var k = 0; k < array_length(targeted_tiles); ++k) {
				if ( targeted_tiles[k, 0] == movement_tile.x + _hmov && targeted_tiles[k, 1] == movement_tile.y + _vmov) {
					_in_mov_range = true;
					break;
				}
			}
				
			if (!_in_mov_range || unit_in_tile(movement_tile.x + _hmov, movement_tile.y + _vmov)) {
				_hmov = 0;
				_vmov = 0;
			}
		}
		
		movement_tile.x = clamp(movement_tile.x + _hmov, max(0, _user.unit.position.x - _range), min(array_length(grid[0])-1, _user.unit.position.x + _range));
		movement_tile.y = clamp(movement_tile.y + _vmov, max(0, _user.unit.position.y - _range), min(array_length(grid)-1, _user.unit.position.y + _range));
	
		path = get_shortest_path_array(
			grid, 
			units[turns].unit.position.x, 
			units[turns].unit.position.y,
			movement_tile.x,
			movement_tile.y,
			true
		);
		
		array_insert(path, 0, [units[turns].unit.position.x, units[turns].unit.position.y]);
		if (array_length(path) > units[turns].unit.movement + 1) {
			var _diff = array_length(path) - units[turns].unit.movement+1;
			array_delete(path, units[turns].unit.movement+1, _diff);
		}
	
		if (array_length(path) > 1 && confirm_input || mouse_check_button_pressed(mb_left)) {
			move_unit_path(units[turns], path);
			path = [];

			movement_actions--;
		}
	}
	
	if (cancel_input) {
		state = battle_end_state_move;
	}
}	

function battle_end_state_move() {
	if (instance_exists(target_indicator)) {
		instance_destroy(target_indicator);
	}
	
	if (!animating) {
		state = prev_state;
	}
}