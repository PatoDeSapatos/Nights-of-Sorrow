global.enemy_ui = {
	simple: function(_id) {
		var _give_extra = false;
		var _give_extra_chance = 50;
		var _possible_gives = [];
		
		var _can_move = !obj_battle_manager.extra_action;
		
		with(obj_battle_manager) {
			if (!extra_turn_given && extra_action) {
				if (irandom_range(1, 100) >= _give_extra_chance) {
					_give_extra = true;
				}
			}
			
			if (_give_extra) {
				_possible_gives = array_filter(units, function(_unit) {
					return _unit.unit.is_enemy && _unit != obj_battle_manager.extra_turn_user;
				});
			
				if (array_length(_possible_gives) <= 0) {
					_give_extra = false;	
				}	
			}
		}

		if (!_give_extra) {
			// Attack random unit
			with (_id) {
				var _possible_targets = array_filter(obj_battle_manager.units, function(_unit) {
					return (!_unit.unit.is_enemy && _unit.unit.hp > -1);
				});
		
				if (array_length(_possible_targets) <= 0) {
					ready = true;	
					return;
				}
		
				var _target = _possible_targets[0];
		
				var _distances = [];
		
				for (var i = 0; i < array_length(_possible_targets); ++i) {
					var _target = _possible_targets[i];
			
					var _distance = abs(unit.position.x - _target.unit.position.x) + abs(unit.position.y - _target.unit.position.y);
					array_push(_distances, [_distance, _target])
				}
		
				array_sort(_distances, function (a, b) {
					return a[0]-b[0];
				});
			
				_target = _distances[0, 1];
		
				if (array_length(_possible_targets) > 1) { 
					if ( (_distances[0, 0] - _distances[1, 0]) <= 5 && _distances[1,0] < unit.movement ) {
						_target = _distances[irandom_range(0, 1), 1];
					}
				}
		
				if (_can_move) {
					var _path = [];
					with (obj_battle_manager) {
						_path = get_shortest_path_array(grid, other.unit.position.x, other.unit.position.y, _target.unit.position.x, _target.unit.position.y, true);
					}
				
					if (array_length(_path) > unit.enemy_info.movement) {
						array_resize(_path, unit.enemy_info.movement);
					}
		
					array_resize(_path, array_length(_path) - 1);
					move_unit_path(self, array_filter(_path, function(_value) {
						return is_array(_value);	
					}));
				}
		
				ready = true;
				unit_use_action(unit.enemy_info.actions[0], _id, [_target]);
				obj_battle_manager.main_actions--;
				obj_battle_manager.extra_action = false;
			}
		} else {
			var _target = _possible_gives[irandom_range(0, array_length(_possible_gives)-1)];
			
			obj_camera.follow = _target;
			with (obj_battle_manager) {
				extra_action = true;
				main_actions = 1;
				extra_turn_user = _target;
				extra_turn_given = true;
			}
		}
	}
}