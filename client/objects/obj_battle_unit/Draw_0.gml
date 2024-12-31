/// @description Insert description here
draw_text(x, y - (sprite_get_height(sprite_index)/2 + 2)*image_yscale, unit.hp);
if (in_target) {
	draw_sprite_ext(spr_battle_targeting, 0, x, y - ((sprite_get_height(sprite_index)-5)*image_yscale)/2, image_xscale, image_yscale, 0, c_white, 1);
}