/// @description Insert description here
if ( follow != noone && instance_exists(follow) || is_struct(follow) ) {
	target_x = follow.x;
	target_y = follow.y;
	
	x = lerp(x + x_buffer, target_x, camera_delay);
	y = lerp(y + y_buffer, target_y, camera_delay);
}

//x_buffer = lerp(x_buffer, x_buffer_target, x_buffer_rate);
//y_buffer = lerp(y_buffer, y_buffer_target, y_buffer_rate);

//if (abs(x_buffer - x_buffer_target) <= x_buffer_rate) {
//	x_buffer = x_buffer_target;	
//}

//if (abs(y_buffer - y_buffer_target) <= y_buffer_rate) {
//	y_buffer = y_buffer_target;	
//}

if (state != noone) {
	state();	
}

if ( global.can_zoom ) { 
	var _wheel = mouse_wheel_down() - mouse_wheel_up();
	
	if ( _wheel != 0 ) {
		_wheel *= 0.1;
 		
		var _add_w = camera_w * _wheel;
		var _add_h = camera_h * _wheel;
		
		camera_w += _add_w;
		camera_h += _add_h;
		
		camera_w = clamp(camera_w, RES_W/4, RES_W * 4);
		camera_h = clamp(camera_h, RES_H/4, RES_H * 4);
	}
}
camera_set_view_size( view_camera[0], camera_w, camera_h );

if (inside_room_camera) { 
	x = clamp(x, camera_w * 0.5, room_width - (camera_w * 0.5));
	y = clamp(y, camera_h * 0.5, room_height - (camera_h * 0.5));
}
camera_set_view_pos( view_camera[0], x - (camera_w*0.5), y - (camera_h*0.5) );
camera_x = camera_get_view_x(view_camera[0]);
camera_y = camera_get_view_y(view_camera[0]);

if (keyboard_check_pressed(ord("V"))) {
	if (view_visible[1] == 0) {
		view_visible[1] = 1
		camera_set_view_size(view_camera[1], room_width, room_height)
	} else {
		view_visible[1] = 0
	}
}
