/// @description
if (!instance_exists(obj_battle_manager)) {	
	instance_destroy();
	return;
}

can_draw = !battle_check_animating() && obj_battle_manager.state == battle_state_turn || obj_battle_manager.state == battle_state_extra;

if (can_draw) {
	// Mouse
	if (hover_option != noone && hover_option.able && variable_instance_get(obj_battle_manager, "l_click")) {
		exit_state_turn(hover_option.state);
		return;
	}

	// Keyboard
	for (var i = 0; i < array_length(options); ++i) {
	    if( options[i].able && variable_instance_get(obj_battle_manager, options[i].input_name) ) {
			exit_state_turn(options[i].state);
			break;
		}
	}
	
	// Other controls
	for (var i = 0; i < array_length(controls); ++i) {
	    if (variable_instance_get(obj_battle_manager, controls[i].input_name)) {
			controls[i].state();
			break;
		}
	}
	
	// Camera
	with(global.camera) {
		var _buffer_x = clamp((mouse_x - camera_x - camera_w/2)/300, -100, 100);
		var _buffer_y = clamp((mouse_y - camera_y - camera_h/2)/300, -100, 100);
		
		camera_set_x_buffer(_buffer_x, .2);
		camera_set_y_buffer(_buffer_y, .2);
	}
	
	camera_zoom(25, true, .25);
	camera_set_bar(50, .15);
}
