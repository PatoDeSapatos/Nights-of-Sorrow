/// @description

// Pre setted variables
// grid = [[]]
// allies = []
// enemies = []

depth = 10;

if (!is_array(allies) || !is_array(enemies) || !is_array(grid)) {
	instance_destroy();
	return;
}

// Visual Variables
scale = 2;
animating = false;
path = [];
mouse_hover = {
	x: -1,
	y: -1
}

// Grid Variables
tile_size = sprite_get_width(spr_dungeon_tileset) * scale;
grid_w = (array_length(grid[0])/2)*tile_size;
grid_h = (array_length(grid)/2)*tile_size;
init_x = obj_camera.camera_x + obj_camera.camera_w/2;
init_y = obj_camera.camera_y + obj_camera.camera_h/2 - grid_h/2;


// Combat Variables
state = battle_state_init;

units = [];
player_units = [];
queued_allies = [];
queued_enemies = [];
turns = 0;
rounds = 0;

depth = 1000;

// Instantiate Party
for (var i = 0; i < array_length(allies); ++i) {
	var _allie = allies[i];
	var _x = tileToScreenXG(_allie.position.x, _allie.position.y, tile_size, init_x);
	var _y = tileToScreenYG(_allie.position.x, _allie.position.y, tile_size, init_y);
	
    var _unit = instance_create_depth(_x, _y, depth-10, obj_party_unit, {
		unit: _allie,
		scale: scale
	});
	array_push(units, _unit);
	
	if (_allie.is_player) {
		obj_camera.follow = _unit;
		array_push(player_units, _unit);
	}
}

// Instantiate Enemies
for (var i = 0; i < array_length(enemies); ++i) {
	var _enemy = enemies[i];
	var _x = tileToScreenXG(_enemy.position.x, _enemy.position.y, tile_size, init_x);
	var _y = tileToScreenYG(_enemy.position.x, _enemy.position.y, tile_size, init_y);
	
    var _unit = instance_create_depth(_x, _y, depth-10, obj_enemy_unit, {
		unit: _enemy,
		scale: scale
	});
	array_push(units, _unit);
}