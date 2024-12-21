/// @description Insert description here
follow = noone;
camera_w = RES_W;
camera_h = RES_H;
camera_x = 0;
camera_y = 0;

transition = -1;
transition_end = -1;
transition_surface = -1;
transition_progress = 0;
transition_rate = 0.03;
to_stop_transition = false;
transition_callback = -1;

await_min_duration = 0;
out_transition = -1;

target_x = x;
target_y = y;
camera_delay = .05;

// ------------- VFX -------------
state = noone;
inside_room_camera = false;

// Cinematic Bar
cinematic_bar = false;
cinematic_bar_progress = 0;
cinematic_bar_rate = .05;
camera = camera_create_view(0, 0, camera_w, camera_h);
view_set_camera(0, camera);

// Zoom
target_zoom = -1;
zoom_rate = 0.5;

GLOBAL_RES_SCALE = 1280/camera_w;
window_set_size(RES_W * GLOBAL_RES_SCALE, RES_H * GLOBAL_RES_SCALE)
surface_resize(application_surface, RES_W * GLOBAL_RES_SCALE, RES_H * GLOBAL_RES_SCALE);
display_set_gui_size(RES_W * GLOBAL_RES_SCALE, RES_H * GLOBAL_RES_SCALE)
