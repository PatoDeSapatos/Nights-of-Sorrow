function battle_sort_by_speed(_u1, _u2) {
	return unit_get_stats(_u2, "spd") - unit_get_stats(_u1, "spd");
}

function battle_state_init() {
	current_waiting_frames++;
	
	if (current_waiting_frames >= waiting_frames) {
		array_sort(units, battle_sort_by_speed);
		state = battle_state_start_turn;
	}
}

function battle_state_start_turn() {
	if (battle_check_animating()) return;
	
	movement_actions = 1;
	main_actions = 1;
	
	with(obj_battle_unit) {
		if (!is_dead) {
			obj_battle_manager.grid[unit.position.x, unit.position.y].coll = true;
		}
	}
	
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
	
	if (units[turns].unit.hp <= 0) {
		add_battle_text( string("{0} is fainted.", units[turns].unit.name) );
		units[turns].ready = true;
		state = battle_state_waiting;
	} else if (units[turns].unit.is_player) {			
		state = battle_state_turn;
	} else if ( battle_host == obj_server.username && units[turns].unit.is_enemy ) {
		state = battle_state_enemy_turn;
	} else {
		state = battle_state_waiting;
	}
}

function battle_state_turn() {
			
	player_turn = true;
	
	check_charging();
	
	// Main Action
	if (main_actions > 0) {
		check_attack();
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
		units[turns].ready = true;
		player_turn = false;
		state = battle_state_waiting;			
	}
}

function set_state_targeting(_action) {
	var _user = extra_action ? extra_turn_user : units[turns];
	selected_action = _action;
	action_targets = [];
	current_target = 0;
	prev_state = state;
	
	if (selected_action.range != -1) {
		var _range = selected_action.range;
		
		action_tiles = [];
		for (var _y = -_range; _y <= _range; ++_y) {
			for (var _x = -_range; _x <= _range; ++_x) {
				var _xx = _user.unit.position.x + _x;
				var _yy = _user.unit.position.y + _y;
			   
				var _value = floor(sqrt(sqr(_user.unit.position.x - _xx) + sqr(_user.unit.position.y - _yy)));

				if (_value <= _range && _xx >= 0 && _yy >= 0 && _xx <= array_length(grid[0]) && _yy <= array_length(grid)) {
					array_push(action_tiles, [_xx, _yy]);   
				}
			}
		}	
	}
	
	// Filter possible targets
	if (selected_action.targetRequired) {		
		action_possible_targets = array_filter(units, function(_unit) {
			var _user = extra_action ? extra_turn_user : units[turns];
			var _select = true;
			
			if (!struct_exists(selected_action, "targetDead") || !selected_action.targetDead) {
				_select = _select && _unit.unit.hp > 0;	
			}
			
			if (!struct_exists(selected_action, "targetSelf") || !selected_action.targetSelf) {
				_select = _select && _unit != _user;	
			}
			
			if (selected_action.range != -1) {
				_select = _select && calc_unit_distance(_user, _unit) <= selected_action.range;
			}
			
			return _select;
		});
		
		if (array_length(action_possible_targets) <= 0) {
			state = battle_state_turn;
			add_battle_text("No possible targets.");
			return;
		}
		
		if (struct_exists(selected_action, "prioritizeEnemies")) {
			array_sort(action_possible_targets, function (_unit) {
				return obj_battle_manager.selected_action.prioritizeEnemies ? !_unit.unit.is_enemy : _unit.unit.is_enemy;
			});	
		}
		
		if (instance_exists(unit_hover)) {
			array_sort(action_possible_targets, function (_unit) {
				return _unit == obj_battle_manager.unit_hover;
			});
		}
		
		var _first_target = action_possible_targets[0];
		target_indicator = instance_create_depth(_first_target.x, _first_target.y, _first_target.depth - 10, obj_target_indicator);
		target_indicator.target = _first_target;
	}
	
	state = battle_state_targeting;
}

function battle_state_targeting() {
	var _user = extra_action ? extra_turn_user : units[turns];
	
	// No target action
	if (!selected_action.targetRequired) {
		unit_use_action( selected_action, _user, noone );
		main_actions--;
		end_state_targeting();
		return;
	}

	// Cancel targeting
	if (cancel_input) {
		end_state_targeting();
	}
	
	if (struct_exists(selected_action, "targetCount")) {
		var _offset = right_input - left_input;
		
		current_target = clamp(current_target + _offset, 0, array_length(action_possible_targets)-1);
		if (instance_exists(action_possible_targets[current_target])) {
			var _target = action_possible_targets[current_target];
			global.camera.follow = _target;
			target_indicator.target = _target;
			
			if (confirm_input) {
				array_push(action_targets, _target);	
			}
		}

		// End targeting	
		if (array_length(action_targets) >= selected_action.targetCount) {
			if (struct_exists(selected_action, "charge") && selected_action.charge) {
				with (_user) {
					charging_targets = other.action_targets;
					charging_action = other.selected_action;
				}
				end_state_targeting();
				return;
			}
			
			unit_use_action(selected_action, _user, action_targets);			
			main_actions--;
			extra_action = false;
			end_state_targeting();
		}
	}
}

function end_state_targeting() {
	selected_action = noone;
	action_targets = [];
	action_possible_targets = [];
	
	if (instance_exists(target_indicator)) instance_destroy(target_indicator);
	
	global.camera.follow = extra_turn_user != noone ? extra_turn_user : units[turns];
	state = prev_state;
	prev_state = noone;
}

function battle_state_extra() {
	check_charging();
	
	// Main Action
	if (extra_action) {
		check_attack();
	}
	
	// Give Extra Turn
	if (!extra_turn_given && keyboard_check_pressed(ord("G"))) {
		extra_units = array_filter(units, function(_unit) {
			return !_unit.unit.is_enemy && _unit != obj_battle_manager.extra_turn_user && !_unit.is_dead;
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
			if (!extra_turn_given) extra_action = false;
		}

		state = battle_state_waiting;
	}	
}

function battle_state_waiting() {
	if (keyboard_check_pressed(ord("R"))) {
		units[turns].ready = true;	
	}
	
	// Animate death (brutal)
	with (obj_battle_unit) {
		if (unit.hp <= 0 && !is_dead) {
			var _cutscene = [];
			unit.condition = noone;
			is_dead = true;
			
			if ( struct_exists(unit.sprites, "dying") ) {
				array_push(_cutscene, [cutscene_animate_once, self, unit.sprites.dying]);	
			}
			
			if ( struct_exists(unit.sprites, "dead") ) {
				array_push(_cutscene, [cutscene_change_sprite, self, unit.sprites.dead]);	
			}
			
			battle_create_cutscene(_cutscene);
		}
	}
	
	if (!animating) {
		
		if (extra_action && extra_turn_user != noone) {
			if(extra_turn_user.unit.player_username == global.server.username) {
				extra_turn_user.ready = false;
				state = battle_state_extra;	
			} else if (battle_host == global.server.username && extra_turn_user.is_enemy) {
				state = battle_state_enemy_turn;
			}
		}
		
		current_waiting_frames++;
		
		if (current_waiting_frames >= waiting_frames) {
			if (units[turns].ready || extra_turn_user.ready) {
				state = battle_state_end_turn;
			}
			
			current_waiting_frames = 0;
		}
		
		battle_check_over();
	}
}

function battle_check_animating() {
	var _animating = instance_exists(obj_cutscene) || instance_exists(obj_battle_effect);
	
	if (!_animating) {
		for (var i = 0; i < array_length(units); ++i) {
		    if (units[i].animating) {
				_animating = true;
				break;
			}
		}
	}
	
	return _animating;
}

function battle_state_end_turn() {
	if (animating) { 
		return;
	}

	var _unit = units[turns];
	
	with(_unit) {
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
		// Trigger effect
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

	battle_check_over();
	state = battle_state_start_turn;
}

function check_charging() {
	var _user = extra_action ? extra_turn_user : units[turns];
	
	if ((main_actions > 0 || extra_action) && _user.charging_action != noone && _user.charging_targets != noone) {
		if (_user.charging_turns >=_user.charging_action.chargingTurns-1) {
			add_battle_text( string("{0} move has charged!", _user.unit.name));
		} else {
			add_battle_text( string("{0} is charging!", _user.unit.name));
		}
		
		unit_use_action(_user.charging_action, _user, _user.charging_targets);
		main_actions = 0;
		movement_actions = 0;
		extra_action = false;
	}
}

function check_attack() {	
	if (keyboard_check_pressed(ord("A")) || (l_click && unit_hover != noone && !unit_hover.is_dead)) {
		set_state_targeting(global.actions.attack);
	}
		
	if (keyboard_check_pressed(ord("Q"))) {
		set_state_targeting(global.actions.lightRay);
	}
		
	if (keyboard_check_pressed(ord("D"))) {
		set_state_targeting(global.actions.attackBoost);
	}
		
	if (array_length(units[turns].unit.inventory) > 0 && keyboard_check_pressed(ord("I"))) {
		unit_use_action(global.actions.useItem, units[turns], units[turns].unit.inventory[0]);
		main_actions--;
	}
	
	if (keyboard_check_pressed(ord("R"))) {
		main_actions--;
		movement_actions--;
		extra_action = false;
	}
}

function battle_check_over() {
	var _allies_win = true;
	var _enemies_win = true;
	
	for (var i = 0; i < array_length(allies); ++i) {
	    if (allies[i].hp > 0) {
			_enemies_win = false;
			break;
		}
	}
	
	for (var i = 0; i < array_length(enemies); ++i) {
	    if (enemies[i].hp > 0) {
			_allies_win = false;
			break;
		}
	}
	
	if ( _allies_win || _enemies_win ) {
		current_waiting_frames = 0;
		state = end_battle;
	}
}

function end_battle() {
	current_waiting_frames++;
	
	if (current_waiting_frames >= waiting_frames) {
		for (var i = 0; i < array_length(units); ++i) {
		    var _unit = units[i];
			
			if (_unit.is_dead) {
				create_unit_corpse(_unit);	
			}
		}
		
		show_message("Cabou!")
		instance_destroy(obj_battle_unit);
		instance_destroy(obj_battle_effect);
		instance_destroy(obj_battle_manager);
	}
}