/// @description
if (instance_exists(target)) {
	x = target.x;
	y = target.y - ((sprite_get_height(target.sprite_index)-5)*target.image_yscale)/2;
	depth = target.depth - 10;
	image_xscale = target.image_xscale;
	image_yscale = target.image_yscale;
}