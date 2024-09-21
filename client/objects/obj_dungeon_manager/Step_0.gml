/// @description Inserir descrição aqui
if ( instance_exists(obj_player) ) {
	with (obj_player) {
		var player_bottom_x = screenToTileX(x, y) - 1;
		var player_bottom_y = screenToTileY(x, y) - 1;

		depth = -(tileToScreenY(player_bottom_x, player_bottom_y));

		if (player_username == global.server.username) {
			other.player_bottom = other.grid[# player_bottom_x, player_bottom_y];
			other.radar.player_x = player_bottom_x
			other.radar.player_y = player_bottom_y
		}
	}
}

var mouse_tilled_x = screenToTileX(mouse_x, mouse_y)
var mouse_tilled_y = screenToTileY(mouse_x, mouse_y)

if ((mouse_tilled_x > 0 && mouse_tilled_x < width) && (mouse_tilled_y > 0 && mouse_tilled_y < height)) {
	selected = grid[# mouse_tilled_x, mouse_tilled_y];
}