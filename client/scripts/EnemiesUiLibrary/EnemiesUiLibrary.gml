global.enemy_ui = {
	simple: function(_id) {
		// Attack random unit
		with (_id) {
			var _possible_targets = array_filter(obj_battle_manager.units, function(_unit) {
				return (!_unit.unit.is_enemy && _unit.unit.status.hp > -1);
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
				if ( (_distances[0, 0] - _distances[1, 0]) <= 5 ) {
					_target = _possible_targets[irandom_range(0, 1), 1];
				}
			}
		
			var _path = [];
			with (obj_battle_manager) {
				_path = get_shortest_path_array(grid, other.unit.position.x, other.unit.position.y, _target.unit.position.x, _target.unit.position.y);
			}
		
			if (array_length(_path) > unit.enemy_info.movement) {
				array_resize(_path, unit.enemy_info.movement);
			}
		
			array_resize(_path, array_length(_path) - 1);
		
			ready = true;
			move_unit_path(self, array_filter(_path, function(_value) {
				return is_array(_value);	
			}));
		}
	}
}