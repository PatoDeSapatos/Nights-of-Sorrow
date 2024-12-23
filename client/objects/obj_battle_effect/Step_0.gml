/// @description
obj_battle_manager.animating = true;

if (image_index >= sprite_get_number(sprite_index)-1) {
	obj_battle_manager.animating = false;
	instance_destroy();	
}