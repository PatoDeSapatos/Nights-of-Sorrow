function BattleUnit(_status, _inventory, _position, _sprites, _movement, _weakness, _resistences, _attack_types, _player_username) constructor {
	status = _status;
	inventory = _inventory;
	position = _position;
	sprites = _sprites;
	movement = _movement;
	weakness = _weakness;
	resistences = _resistences;
	attack_types = _attack_types ;
	player_username = _player_username;
	is_player = _player_username == global.server.username;
	is_enemy = false;
	focus = false;
}

function EnemyUnit(_position, _enemy_id) : BattleUnit(_position) constructor {
	enemy_info = get_enemy(_enemy_id);
	position = _position;
	status = enemy_info.status;
	sprites = enemy_info.sprites;
	weakness = enemy_info.weakness;
	resistences = enemy_info.resistences;
	attack_types = enemy_info.attack_types;
	movement = enemy_info.movement;
	
	is_player = false;
	is_enemy = true;
	inventory = [];
}

function init_demo_battle(_grid_size) {
	global.server.username = "battle_demo";
	var _player_sprites = new SpriteSet(0, 0, 0, 0, 0);
	
	var _player_unit1 = new BattleUnit(new Status(10, 10, 10, 5, 5, 10, 0), [], {x: 0, y: 0}, _player_sprites, 6, [MOVE_TYPES.BLUDGEONING], [], [MOVE_TYPES.FIRE], global.server.username);
	var _player_unit2 = new BattleUnit(new Status(10, 10, 10, 5, 5, 10, 0), [], {x: 0, y: 1}, _player_sprites, 6, [MOVE_TYPES.BLUDGEONING], [], [MOVE_TYPES.FIRE], global.server.username);
	var _player_unit3 = new BattleUnit(new Status(10, 10, 10, 5, 5, 10, 0), [], {x: 0, y: 2}, _player_sprites, 6, [MOVE_TYPES.BLUDGEONING], [], [MOVE_TYPES.FIRE], global.server.username);
	
	var _enemy1 = new EnemyUnit({x: 1, y: 0}, "SLIME");
	var _enemy2 = new EnemyUnit({x: 1, y: 1}, "SLIME");
	
	var _allies = [ _player_unit1, _player_unit2, _player_unit3 ];	
	var _enemies = [ _enemy1, _enemy2 ];	
	
	var _grid = [];
	for (var i = 0; i < _grid_size; ++i) {
		_grid[i] = [];
	    for (var j = 0; j < _grid_size; ++j) {
		    _grid[i][j] = new Tile(1, false);
		}
	}
	
	init_battle(_grid, _allies, _enemies, obj_server.username);		
}

function init_battle(_grid, _allies, _enemies, _battle_host) {
	
	instance_create_depth(0, 0, 0, obj_battle_manager, {
		grid: _grid,
		allies: _allies,
		enemies: _enemies,
		battle_host: _battle_host
	});
}


function move_unit_path(_id, _path) {
	if (!instance_exists(obj_cutscene) && array_length(_path) > 0) {
		with (obj_battle_manager) {
			animating = true;
			
			grid[_id.unit.position.x, _id.unit.position.y].coll = false;

			var _cutscene = [];
			for (var i = 0; i < array_length(_path); ++i) {
				var _xx = tileToScreenXG(_path[i, 0], _path[i, 1], tile_size, init_x);
				var _yy = tileToScreenYG(_path[i, 0], _path[i, 1], tile_size, init_y);
			    array_push(_cutscene, [cutscene_move_character, _id, _xx, _yy, false, 2]);
			}
		
			instance_create_depth(0, 0, -1000, obj_cutscene, {
				cutscene: _cutscene	
			});
		
			var _x = _path[max(0, array_length(_path) - 1), 0];
			var _y = _path[max(0, array_length(_path) - 1), 1];
		
			with(_id) {
				unit.position.x = _x;
				unit.position.y = _y;
			}
		}
	}
	
}

function unit_use_action(_action, _user, _targets) {
	with (obj_battle_manager) {
		if (_action.range != -1) {
			var _path = get_shortest_path_array(grid, _user.unit.position.x, _user.unit.position.y, _targets[0].unit.position.x, _targets[0].unit.position.y);
			if (array_length(_path) > _action.range) {
				return;	
			}
		}
		
		var _cutscene = [cutscene_use_action,_user, _action, _targets];
		if (!instance_exists(obj_cutscene)) {
			animating = true;
			instance_create_depth(0, 0, -1000, obj_cutscene, {
				cutscene: [_cutscene]
			})
		} else {
			array_push(obj_cutscene.cutscene, _cutscene);	
		}
	}	
}

function unit_take_damage(_damage, _target, _types, _is_physical) {
	with (_target) {
		var _defense = (_is_physical) ? unit.status.defense : unit.status.magic_defense;
		var _resistance_multiplier = 0;
		for (var i = 0; i < array_length(_types); ++i) {
		    if (array_contains(_target.unit.weakness, _types[i])) {
				_resistance_multiplier++;
			}
			if (array_contains(_target.unit.resistences, _types[i])) {
				_resistance_multiplier--;	
			}
		}
		
		with (obj_battle_manager) {
			if (!_target.is_broken && _resistance_multiplier > 0) {
				_target.is_broken = true;
				extra_turn_given = false;
				extra_action = true;	
			}
		}
		
		var _final_damage = round( (_damage - (_defense/(_defense + 100))));
		_final_damage = round(_final_damage + _final_damage*_resistance_multiplier*.5);
		if (_final_damage > 0) _target.unit.focus = false; 
		
		battle_change_hp(_target, -_final_damage);
	}
}

function battle_change_hp(_target, _amount) {
	var _col = (_amount > 0) ? (c_green) : (c_red);

	instance_create_depth(_target.x + random_range(-20, 20), _target.y + random_range(-20, 20), _target.depth-1000, obj_battle_floating_text, {
		text: _amount,
		col: _col,
		font: fnt_inventory_title
	})
	
	unit.status.hp = max(0, unit.status.hp + _amount);
}