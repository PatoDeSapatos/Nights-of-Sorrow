function BattleUnit(_stats, _max_hp, _hp, _inventory, _position, _sprites, _movement, _weakness, _resistences, _attack_types, _player_username, _stat_changes=new Stats(), _condition=noone) constructor {
	name = _player_username;
	stats = _stats;
	max_hp = _max_hp;
	hp = _hp;
	stat_changes = _stat_changes;
	inventory = _inventory;
	position = _position;
	sprites = _sprites;
	movement = _movement;
	weakness = _weakness;
	resistences = _resistences;
	attack_types = _attack_types ;
	player_username = _player_username;
	is_player = _player_username == global.server.username;
	condition = _condition;
	is_enemy = false;
	focus = false;
}

function EnemyUnit(_position, _enemy_id, _stat_changes=new Stats(), _condition=noone) : BattleUnit(_position, _stat_changes, _condition) constructor {
	enemy_info = get_enemy(_enemy_id);
	name = enemy_info.display_name;
	position = _position;
	stats = enemy_info.stats;
	stat_changes = _stat_changes;
	max_hp = enemy_info.stats.hp;
	hp = max_hp;
	sprites = enemy_info.sprites;
	weakness = enemy_info.weakness;
	resistences = enemy_info.resistences;
	attack_types = enemy_info.attack_types;
	movement = enemy_info.movement;
	condition = _condition;
	
	is_player = false;
	is_enemy = true;
	inventory = [];
}

function init_demo_battle(_grid_size) {
	global.server.username = "battle_demo";
	var _player_sprites = new SpriteSet(0, 0, 0, 0, 0);
	
	var _player_unit1 = new BattleUnit(new Stats(10, 10, 10, 5, 5, 10, 0), 10, 10, [], {x: 0, y: 0}, _player_sprites, 6, [MOVE_TYPES.BLUDGEONING], [], [MOVE_TYPES.FIRE], global.server.username);
	var _player_unit2 = new BattleUnit(new Stats(10, 10, 10, 5, 5, 10, 0), 10, 10, [], {x: 0, y: 2}, _player_sprites, 6, [MOVE_TYPES.BLUDGEONING], [], [MOVE_TYPES.FIRE], global.server.username);
	
	var _enemy1 = new EnemyUnit({x: 1, y: 0}, "SLIME", new Stats());
	var _enemy2 = new EnemyUnit({x: 2, y: 1}, "SLIME", new Stats());
	
	var _allies = [ _player_unit1, _player_unit2 ];	
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
			if (calc_unit_distance(_user, _targets[0]) > _action.range) {
				return;	
			}
		}
		
		var _cutscene = [cutscene_use_action,_user, _action, _targets];
		battle_create_cutscene([_cutscene])
	}	
}

function unit_take_damage(_damage, _user, _target, _types, _is_physical) {
	with (_target) {
		var _defense = (_is_physical) ? (unit_get_stats(_target, "defense")) : (unit_get_stats(_target, "magic_defense"));
		
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
				extra_turn_user = _user;
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
	
	unit.hp = max(0, unit.hp + _amount);
}

function battle_inflict_condition(_target, _condition, _chance_percentage) {
	if (_target.unit.condition == _condition) {
		add_battle_text( string("{0} is already {1}", _target.unit.name, _condition.inflict_name) );
		battle_text_set_color(_condition.col, 3, 3);
		return;
	}
	
	var _success = irandom_range(1, 100) <= _chance_percentage;
	if (!_success) return;

	var _cutscene = [];

	if (!is_undefined(_condition.effect_spr)) {
		array_push(_cutscene, [cutscene_instance_create_depth, _target.x, _target.y, _target.depth-1, obj_battle_effect, {sprite_index: _condition.effect_spr}])
	}

	if (struct_exists(_condition, "targetAnimation") && !is_undefined(_condition.targetAnimation) && struct_exists(_target.unit.sprites, _condition.targetAnimation)) {
		array_push(_cutscene, [cutscene_animate_once, _target, _target.unit.sprites[$ _condition.targetAnimation]]);
	}

	add_battle_text( string("{0} has been {1}", _target.unit.name, _condition.inflict_name) );
	battle_text_set_color(_condition.col, 3, 3);
	
	if (array_length(_cutscene) > 0) {
		battle_create_cutscene(_cutscene);
	}
	
	_target.unit.condition = _condition;
}

function battle_create_cutscene(_cutscene) {
	with(obj_battle_manager) {
		var _await = [cutscene_await, waiting_frames];
		array_push(_cutscene, _await)
		
		if (!instance_exists(obj_cutscene)) {
			instance_create_depth(0, 0, -1000, obj_cutscene, {
				cutscene: _cutscene
			})
		} else {
			for (var i = 0; i < array_length(_cutscene); ++i) {
			    array_push(obj_cutscene.cutscene, _cutscene[i]);
			}
		}
	}
}

function battle_activate_condition(_target) {
	with(obj_battle_manager) {
		var _cutscene = [cutscene_activate_condition, _target];
		battle_create_cutscene([_cutscene]);
	}
}

function unit_get_stats(_unit, _stats_name) {
	if (is_undefined( _unit.unit.stats[$ _stats_name])) return undefined;
	
	var _stats = _unit.unit.stats[$ _stats_name];
	var _level = _unit.unit.stat_changes[$ _stats_name];
	var _rate = 4;
	
	return _stats * ((_rate + max(0, _level))/(_rate + min(0, _level)));
}

function battle_change_stats(_target, _stats_name, _amount) {
	if (_amount == 0) return;
	
	var _current_changes = _target.unit.stat_changes[$ _stats_name];
	
	var _cap = 6;
	
	if (_current_changes > _cap) {
		return;
	} else if (_current_changes < -_cap) {
		return;	
	}
	
	var _spr = (_amount > 0) ? (spr_effect_raise_stats) : (spr_effect_lower_stats);
	var _effect = instance_create_depth(_target.x, _target.y, -1000, obj_battle_effect, {
		sprite_index: _spr
	});
	
	_target.unit.stat_changes[$ _stats_name] += _amount;
	_target.unit.stat_changes[$ _stats_name] = clamp(_target.unit.stat_changes[$ _stats_name], -_cap, _cap);
}

function calc_unit_distance(_unit1, _unit2) {
	return floor(sqrt(sqr(_unit1.unit.position.x - _unit2.unit.position.x) + sqr(_unit1.unit.position.y - _unit2.unit.position.y)));
}
