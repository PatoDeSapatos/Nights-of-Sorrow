function BattleUnit(_status, _inventory, _position, _sprites, _is_player=false) constructor {
	status = _status;
	inventory = _inventory;
	position = _position;
	sprites = _sprites;
	is_player = _is_player;
	is_enemy = false;
}

function EnemyUnit(_position, _enemy_id) : BattleUnit(_position) constructor {
	enemy_info = get_enemy(_enemy_id);
	position = _position;
	status = enemy_info.status;
	sprites = enemy_info.walking_spr;
	
	is_player = false;
	is_enemy = true;
	inventory = [];
}

function init_demo_battle(_grid_size) {
	var _player_sprites = new SpriteSet(0, 0, 0, 0, 0);
	
	var _allies = [ new BattleUnit(new Status(), [], {x: 0, y: 0}, _player_sprites, true)  ];	
	var _enemies = [ new EnemyUnit({x: 1, y: 0}, "SLIME")  ];	
	
	var _grid = [];
	for (var i = 0; i < _grid_size; ++i) {
		_grid[i] = [];
	    for (var j = 0; j < _grid_size; ++j) {
		    _grid[i][j] = new Tile(1, false);
		}
	}
	
	obj_server.username = "battle_demo";
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