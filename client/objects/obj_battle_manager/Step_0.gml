/// @description
using_mouse = false;
if (mouse_sx != device_mouse_x_to_gui(0) || mouse_sy != device_mouse_y_to_gui(0)) {
	using_mouse = true;	
}

mouse_sx = device_mouse_x_to_gui(0);
mouse_sy = device_mouse_y_to_gui(0);

unit_hover = noone;
var _mouse_x = mouse_hover.x;
var _mouse_y = mouse_hover.y;

animating = battle_check_animating();

with(obj_battle_unit) {	
	var _x = screenToTileXG(x, y, other.tile_size, other.init_x, other.init_y);
	var _y = screenToTileYG(x, y, other.tile_size, other.init_x, other.init_y);

	if ( (_mouse_x != -1 && _mouse_y != -1) && (_x == _mouse_x && _y == _mouse_y) ) {
		obj_battle_manager.unit_hover = self;
	}

	depth = -(tileToScreenYExt(_x - 1, _y - 1, other.tile_size, other.init_y));
}

if (player_turn && movement_actions > 0) {
	cursor_in_range = false;
	for (var i = 0; i < array_length(targeted_tiles); ++i) {
	    if ( mouse_hover.x == targeted_tiles[i, 0] && mouse_hover.y == targeted_tiles[i, 1] ) {
			cursor_in_range = true;
			break;
		}
	}
}

l_click = mouse_check_button_pressed(mb_left);
left_input = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));

r_click = mouse_check_button_pressed(mb_right);
right_input = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));

up_input = keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up);
down_input = keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down);

confirm_input = keyboard_check_pressed(vk_enter);
cancel_input = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace);

battle_execute_cutscene();

state();
