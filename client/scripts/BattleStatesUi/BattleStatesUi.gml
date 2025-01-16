function battle_start_state_attack() {
	var _skills = [global.actions.attack, global.actions.fireBall, global.actions.attackBoost, global.actions.lightRay, global.actions.poisonMist];
	
	if (array_length(_skills) <= 0) {
		add_battle_text("You have no usable skills.");
		state = prev_state;
		return;
	}
	
	inventory = instance_create_depth(0, 0, -1000, obj_skill_inventory);
	inventory.skills = _skills;
	camera_set_x_buffer(5, .5);
	camera_zoom(10, true);
	state = battle_state_attack;
}

function battle_state_attack() {
	if (instance_exists(inventory)) {
		var _action = inventory.skills[inventory.selected_item];
	
		if (is_struct(_action) && (confirm_input || (l_click && inventory.mouse_hover_option))) {
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

function battle_start_state_item() {
	var _user = extra_action ? extra_turn_user : units[turns];
	var _items = array_filter(_user.unit.inventory, function (_item) {
		return struct_exists(get_item_by_id(_item.id), "action");	
	});
		
	if (array_length(_items) <= 0) {
		add_battle_text("You have no usable items.");
		state = prev_state;
		return;
	}
		
	inventory = instance_create_depth(0, 0, -1000, obj_battle_item_inventory);
	inventory.inventory = _items;
	
	camera_set_x_buffer(5, .5);
	camera_zoom(10, true);
	state = battle_state_item;
}

function battle_state_item() {
	if (instance_exists(inventory) && (confirm_input || (l_click && inventory.mouse_hover_option)) && inventory.selected_item >= 0) {
		var _action = noone;
		
		with(inventory) {
			var _item = get_item_by_id(inventory[selected_item].id);
			
			if (is_struct(_item) && struct_exists(_item, "action")) {
				_action = _item.action;	
			}
		}
	
		if (is_struct(_action)) {
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

function battle_start_state_move() {
	var _user = extra_action ? extra_turn_user : units[turns];
	movement_tile.x = _user.unit.position.x;
	movement_tile.y = _user.unit.position.y;
	
	target_indicator = instance_create_depth(0, 0, -10000, obj_target_indicator);
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

function battle_skip_turn() {
	with(obj_battle_manager) {
		main_actions = 0;
		movement_actions = 0;
		extra_action = false;
	}	
}