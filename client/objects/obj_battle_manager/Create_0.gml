/// @description

// Pre setted variables
// grid = [[]]
// allies = []
// enemies = []

global.loading_screen = true;


if (!is_array(allies) || !is_array(enemies) || !is_array(grid)) {
	instance_destroy();
	return;
}

// Cutscene variables
setup = false;

action = 0;
timer = 0;
x_dest = noone;
y_dest = noone;

image = 0;
cutscene_end = -1;
cutscene_skip = false;
cutscene_skip_percentage = 0;
cutscene_skip_rate = .02;

// Visual Variables
animating = false;
cutscene = [];
scale = 2;
cursor_in_range = false;
path = [];
mouse_hover = {
	x: -1,
	y: -1
}
mouse_sx = -1;
mouse_sy = -1;

// UI
function battle_option(_name, _state, _input_name, _keyboard_key, _console_key) constructor {
	name = _name;	
	state = _state;
	input_name = _input_name;
	keyboard_key = _keyboard_key;
	console_key = _console_key;
}

options = [
	new battle_option("Attack", battle_state_attack, "attack_input", ord("Q"), noone),
	new battle_option("Item", battle_state_item, "item_input", ord("W"), noone),
	new battle_option("Move", battle_state_move, "move_input", ord("E"), noone)
];

option_border = 10;

// Grid Variables
tile_size = sprite_get_width(spr_dungeon_tileset) * scale;
grid_w = (array_length(grid[0])/2)*tile_size;
grid_h = (array_length(grid)/2)*tile_size;
init_x = obj_camera.camera_x + obj_camera.camera_w/2;
init_y = obj_camera.camera_y + obj_camera.camera_h/2 - grid_h/2;

// inputs
using_mouse = false;
r_click = false;
l_click = false;
left_input = false;
right_input = false;
up_input = false;
down_input = false;
confirm_input = false;
cancel_input = false;

attack_input = false;
item_input = false;
move_input = false;

// Combat Variables
state = battle_state_init;
prev_state = noone;

action_tiles = [];
action_done = false;
action_targets = [];
action_possible_targets = [];
selected_action = noone;
current_target = 0;
target_indicator = noone;
action_area = [];
action_origin = {
	x: 0,
	y: 0
}

player_turn = false;
units = [];
player_units = [];
queued_allies = [];
queued_enemies = [];
turns = 0;
rounds = 0;

targeted_tiles = [];

unit_hover = noone;

movement_actions = 0;
main_actions = 0;
special_actions = 0;

extra_action = false;
extra_turn_user = noone;
extra_turn_given = false;

waiting_frames = FRAME_RATE div 2;
current_waiting_frames = 0;

depth = 1000;

// Instantiate Party
for (var i = 0; i < array_length(allies); ++i) {
	var _allie = allies[i];
	var _x = tileToScreenXExt(_allie.position.x, _allie.position.y, tile_size, init_x);
	var _y = tileToScreenYExt(_allie.position.x, _allie.position.y, tile_size, init_y);
	
    var _unit = instance_create_depth(_x, _y, depth-10, obj_party_unit, {
		unit: _allie,
		scale: scale
	});
	array_push(units, _unit);
	
	if (_allie.is_player) {
		array_push(player_units, _unit);
	}
}

// Instantiate Enemies
for (var i = 0; i < array_length(enemies); ++i) {
	var _enemy = enemies[i];
	var _x = tileToScreenXExt(_enemy.position.x, _enemy.position.y, tile_size, init_x);
	var _y = tileToScreenYExt(_enemy.position.x, _enemy.position.y, tile_size, init_y);
	
    var _unit = instance_create_depth(_x, _y, depth-10, obj_enemy_unit, {
		unit: _enemy,
		scale: scale
	});
	array_push(units, _unit);
}

global.loading_screen = false;