function battle_sort_by_speed(_u1, _u2) {
	return _u1.unit.status.spd - _u2.unit.status.spd;
}

function battle_state_init() {
	array_sort(units, battle_sort_by_speed);
	state = battle_state_start_turn;
}

function battle_state_start_turn() {
	obj_camera.follow = units[turns];
	
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

function battle_state_turn() {
	if (!animating && mouse_hover.x != -1 && mouse_hover.y != -1) {
		path = get_shortest_path_array(
			grid, 
			player_units[0].unit.position.x, 
			player_units[0].unit.position.y,
			mouse_hover.x,
			mouse_hover.y
		);
		array_insert(path, 0, [player_units[0].unit.position.x, player_units[0].unit.position.y]);
	
		if (array_length(player_units) > 0 && mouse_check_button_pressed(mb_left)) {
			move_unit_path(player_units[0], path);
			path = [];
			
			state = battle_state_waiting;
			units[turns].ready = true;
		}	
	}		
}

function battle_state_waiting() {
	if (keyboard_check_pressed(ord("R"))) {
		units[turns].ready = true;	
	}
	
	if (units[turns].ready && !animating) {
		units[turns].ready = false;
		state = battle_state_end_turn;
	}
}

function battle_state_enemy_turn() {
	if ( battle_host == obj_server.username && units[turns].unit.is_enemy ) {
		with (units[turns]) {
			unit.enemy_info.battle_script(self);
		}
		state = battle_state_waiting;
	}	
}

function battle_state_end_turn() {
	turns++;
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