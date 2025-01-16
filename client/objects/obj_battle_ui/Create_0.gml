/// @description
function battle_option(_name, _state, _input_name, _key, _console_key) constructor {
	name = _name;	
	state = _state;
	input_name = _input_name;
	key = _key;
	console_key = _console_key;
	
	able = true;
}

// Options
options = [
	new battle_option("Move", battle_start_state_move, "move_input", ord("E"), noone),
	new battle_option("Item", battle_start_state_item, "item_input", ord("W"), noone),
	new battle_option("Attack", battle_start_state_attack, "attack_input", ord("Q"), noone),
];

controls = [
	new battle_option("End Turn", battle_skip_turn, "skip_input", ord("R"), noone),
	new battle_option("Move Camera", battle_skip_turn, "move_camera_input", ord("M"), noone)
]

scale = obj_battle_manager.scale;
distance = 37 * scale;
option_border = 10 * scale;
hover_option = noone;
can_draw = false;

inventory = noone;