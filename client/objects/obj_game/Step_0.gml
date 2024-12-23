/// @description Insert description here
if ( keyboard_check_pressed(vk_f1) ) {
	if (instance_exists(obj_dungeon_manager)) instance_destroy(obj_dungeon_manager);
	game_restart();
}

if (instance_exists(obj_wall)) {
	if (keyboard_check_pressed(ord("Z"))) {
		instance_deactivate_object(obj_wall);
	}
} else if (keyboard_check_pressed(ord("X"))) {
	instance_activate_object(obj_wall);	
}

if (keyboard_check_pressed(ord("E")) && !instance_exists(obj_battle_manager)) {
	init_demo_battle(20);
}

if (keyboard_check_pressed(ord("Z"))) {
	camera_zoom(25);
}

if (keyboard_check_pressed(ord("T"))) {
	add_battle_text("Felpos has been poisoned.");
	battle_text_set_color(c_purple, 3, 3);
	
	add_battle_text("Thugas has been paralyzed.");
	battle_text_set_color(c_yellow, 3, 3);
}

if (keyboard_check_pressed(ord("X"))) {
	camera_zoom(20, false);
}

if (keyboard_check_pressed(ord("C"))) {
	camera_zoom_reset();
}