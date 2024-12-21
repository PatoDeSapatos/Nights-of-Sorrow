/// @description
unit_hover = noone;
var _mouse_x = mouse_hover.x;
var _mouse_y = mouse_hover.y;

with(obj_battle_unit) {	
	var _x = screenToTileXG(x, y, other.tile_size, other.init_x, other.init_y);
	var _y = screenToTileYG(x, y, other.tile_size, other.init_x, other.init_y);

	if ( (_mouse_x != -1 && _mouse_y != -1) && (_x == _mouse_x && _y == _mouse_y) ) {
		obj_battle_manager.unit_hover = self;
	}

	depth = -(tileToScreenYG(_x - 1, _y - 1, other.tile_size, other.init_y));
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
r_click = mouse_check_button_pressed(mb_right);
confirm_input = keyboard_check_pressed(vk_enter);

state();
