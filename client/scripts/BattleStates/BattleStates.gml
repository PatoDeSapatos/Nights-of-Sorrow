function battle_sort_by_speed(_u1, _u2) {
	return unit_get_stats(_u1, "spd") - unit_get_stats(_u2, "spd");
}

function battle_state_init() {
	array_sort(units, battle_sort_by_speed);
	state = battle_state_start_turn;
}

function battle_state_start_turn() {
	current_waiting_frames++;	
	movement_actions = 1;
	main_actions = 1;
	
	with(obj_battle_unit) {
		obj_battle_manager.grid[unit.position.x, unit.position.y].coll = true;
	}
	
	if (current_waiting_frames >= waiting_frames) {
		current_waiting_frames = 0;	
		obj_camera.follow = units[turns];
		units[turns].is_broken = false;
		
		targeted_tiles = [];
		var _lenght = array_length(obj_battle_manager.grid);
		var _movement = units[turns].unit.movement;
		var _player_x = units[turns].unit.position.x;
		var _player_y = units[turns].unit.position.y;
		
		//for (var _y = _player_y-_movement; _y < _player_y+_movement; ++_y) {
		//	if (_y < 0 || _y >= _lenght) continue;
			  
		//	for (var _x = _player_x-_movement; _x < _player_x+_movement; ++_x) {
		//		if (_x < 0 || _x >= _lenght) continue;	   
		//		if (_x + _y <= _movement) {
		//			array_push(targeted_tiles, [_x, _y]);
		//		}
		//	}
		//}
			
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
	
		if (units[turns].unit.is_player) {			
			state = battle_state_turn;
		} else {
			if ( battle_host == obj_server.username && units[turns].unit.is_enemy ) {
				state = battle_state_enemy_turn;
			} else {
				state = battle_state_waiting;
			}
		}
	}
}

function battle_state_turn() {
			
	player_turn = true;
			
	// Main Action
	if (main_actions > 0) {
		if (check_attack()) {
			unit_use_action(global.actions.attack, units[turns], [unit_hover]);
			main_actions--;
		}
		
		if (keyboard_check_pressed(ord("D"))) {
			unit_use_action(global.actions.attackBoost, units[turns], [units[turns]]);
		}
	}
	
	// Movement player
	if (movement_actions > 0 && unit_hover == noone && !animating && mouse_hover.x != -1 && mouse_hover.y != -1) {
		// Path
		path = get_shortest_path_array(
			grid, 
			units[turns].unit.position.x, 
			units[turns].unit.position.y,
			mouse_hover.x,
			mouse_hover.y,
			true
		);
		array_insert(path, 0, [units[turns].unit.position.x, units[turns].unit.position.y]);
		if (array_length(path) > units[turns].unit.movement + 1) {
			var _diff = array_length(path) - units[turns].unit.movement+1;
			array_delete(path, units[turns].unit.movement+1, _diff);
		}
	
		if (mouse_check_button_pressed(mb_left)) {
			move_unit_path(units[turns], path);
			path = [];

			movement_actions--;
		}	
	}
	
	// End State
	if (!animating && (main_actions <= 0 && special_actions <= 0) || units[turns].ready) {
		if (extra_action) {
			extra_turn_user = units[turns];
			state = battle_state_extra;
		} else {
			units[turns].ready = true;
			player_turn = false;
			state = battle_state_waiting;			
		}
	}
}

function battle_state_extra() {
	// Main Action
	if (check_attack()) {
		unit_use_action(global.actions.attack, extra_turn_user, [unit_hover] );
		extra_action = false;
	}
	
	// Give Extra Turn
	if (!extra_turn_given && keyboard_check_pressed(ord("G"))) {
		extra_units = array_filter(units, function(_unit) {
			return !_unit.unit.is_enemy && _unit != obj_battle_manager.extra_turn_user;
		});
		current_extra_unit = 0;
		
		if (array_length(extra_units) > 0) {
			state = battle_state_extra_choosing;
		}
	}
	
	if (!animating && (!extra_action || extra_turn_user.ready)) {
		extra_turn_user.ready = true;
		extra_action = false;
		state = battle_state_waiting;	
	}
}

function battle_state_extra_choosing() {
	var _curr = extra_units[current_extra_unit];
	obj_camera.follow = _curr;
	
	// Change Unit
	if (keyboard_check_pressed(vk_left)) {
		current_extra_unit--;
	}
	if (keyboard_check_pressed(vk_right)) {
		current_extra_unit++;	
	}
	
	current_extra_unit = clamp(current_extra_unit, 0, array_length(extra_units)-1);
	
	// Select Unit
	if ( confirm_input ) {
		extra_turn_user.ready = true;
		extra_turn_user = _curr;
		obj_camera.follow = _curr;
		extra_turn_given = true;
		state = battle_state_waiting;
	}
	
	// Cancel
	if (keyboard_check_pressed(ord("G"))) {
		obj_camera.follow = extra_turn_user;
		current_extra_unit = 0;
		state = battle_state_extra;
	}
}

function battle_state_enemy_turn() {
	if ( battle_host == obj_server.username && units[turns].unit.is_enemy ) {
		var _user = units[turns];
		
		if (extra_turn_user != noone) {
			_user = extra_turn_user;
		}
		
		if (main_actions > 0 || extra_action) {
			with (_user) {
				unit.enemy_info.battle_script(self);
			}
		}
		
		if (!animating && !extra_action) {
			state = battle_state_waiting;
		}
	}	
}

function battle_state_waiting() {
	if (keyboard_check_pressed(ord("R"))) {
		units[turns].ready = true;	
	}
	
	if (!animating) {
		if (extra_action && extra_turn_user != noone && extra_turn_user.unit.player_username == global.server.username) {
			state = battle_state_extra;	
		} else if (units[turns].ready) {
			state = battle_state_end_turn;
		}
	}
}

function battle_state_end_turn() {
	with(units[turns]) {
		if (unit.condition != noone && unit.condition.trigger == EFFECT_TRIGGERS.END_TURN_SELF) {
			battle_activate_condition(self);
		}
	}
	
	units[turns].ready = false;
	turns++;
	extra_turn_given = false;
	extra_action = false;
	extra_turn_user = noone;
	
	with(obj_battle_unit) {
		if (unit.condition != noone && unit.condition.trigger == EFFECT_TRIGGERS.END_TURN_ALL) {
			battle_activate_condition(self);
		}
	}
	
	if (turns >= array_length(units)) {
		array_sort(units, battle_sort_by_speed);
		turns = 0;
		rounds++;
	}
	
	// TODO instantiate queued units (units waiting to enter the battle)
	if (array_length(queued_allies) > 0) {
	
	}

	state = battle_state_start_turn;
}

function check_attack() {
	return (l_click && unit_hover != noone && unit_hover.object_index == obj_enemy_unit)
}