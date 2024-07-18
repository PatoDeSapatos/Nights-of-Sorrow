/// @description
inventory_open = false;
inventory_size = 64;

// Menu Parameters
gui_w = display_get_gui_width();
gui_h = display_get_gui_height();
border = gui_w div 8;

// Items box
items_box_w = gui_w/2.5;
items_box_h = gui_h;
items_box_x = gui_w - border - items_box_w;
items_box_y = 0;
items_box_border = items_box_w div 10;

items_box_name_x = items_box_x + items_box_border;
items_box_name_y = border;
items_box_name_w = (items_box_w div 2) - items_box_border*2;
items_box_name_h = 100;

items_box_quantity_x = items_box_name_x + items_box_name_w + items_box_border*2;

inventory = [];
