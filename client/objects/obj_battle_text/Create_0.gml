/// @description

texts = [];
text_width = [];
text_height = [];
page = 0;

timer = 0;
waiting_time = 1.5 * FRAME_RATE;
rate = .125;
vanish = false;

gui_w = display_get_gui_width();
gui_h = display_get_gui_height();

start_x = gui_w div 100;
start_y = gui_h div 10;
padding = 20;

curr_x = 0;

target_x = start_x + padding;