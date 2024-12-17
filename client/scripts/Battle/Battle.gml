function BattleUnit(_status, _inventory, _position, _sprites, _is_player=false) constructor {
	status = _status;
	inventory = _inventory;
	position = _position;
	sprites = _sprites;
	is_player = _is_player
}

function init_demo_battle(_grid_size) {
	var _player_sprites = new SpriteSet(0, 0, 0, 0, 0);
	
	var _allies = [ new BattleUnit(new Status(), [], {x: 0, y: 0}, _player_sprites, true)  ];	
	var _enemies = [ new BattleUnit(new Status(), [], {x: 1, y: 0}, spr_slime_idle)  ];	
	
	var _grid = [];
	for (var i = 0; i < _grid_size; ++i) {
		_grid[i] = [];
	    for (var j = 0; j < _grid_size; ++j) {
		    _grid[i][j] = new Tile(1, false);
		}
	}
	
	
	init_battle(_grid, _allies, _enemies);		
}

function init_battle(_grid, _allies, _enemies) {
	
	instance_create_depth(0, 0, 0, obj_battle_manager, {
		grid: _grid,
		allies: _allies,
		enemies: _enemies
	});
}


function move_unit_path(_id, _path) {
	if (!instance_exists(obj_cutscene)) {
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
		
		var _x = _path[array_length(_path) - 1, 0];
		var _y = _path[array_length(_path) - 1, 1];
		
		with(_id) {
			unit.position.x = _x;
			unit.position.y = _y;
		}
	}
	
}