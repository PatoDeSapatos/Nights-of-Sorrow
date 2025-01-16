/// @description Insert description here

if (in_target) {
	var _yoffset = ((sprite_get_height(sprite_index)-5)*image_yscale)/2 - 10;
	var _xoffset = sprite_get_width(spr_stat_bar_outline)/2 - sprite_get_xoffset(spr_stat_bar_outline);
		
	draw_sprite_ext(spr_stat_bar_targeting, 0, x - _xoffset - sprite_get_xoffset(spr_stat_bar_outline), y - _yoffset, 1, 1, 0, c_white, .7);
	draw_sprite_ext(spr_stat_bar_targeting, 0, x - _xoffset - sprite_get_xoffset(spr_stat_bar_outline), y - _yoffset, unit.hp/unit.stats.hp, 1, 0, get_resource_color(RESOURCES.LIFE), 1);
	draw_sprite_ext(spr_stat_bar_outline, 0, x - _xoffset, y - _yoffset, 1, 1, 0, c_white, 1);
	
	draw_sprite_ext(spr_battle_targeting, 0, x, y - _yoffset - sprite_get_height(spr_stat_bar_outline) - 3, image_xscale, image_yscale, 0, c_white, 1);
}