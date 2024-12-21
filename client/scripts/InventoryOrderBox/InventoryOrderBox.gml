function draw_order_box(){
box_delay++;
if (box_delay <= 1) return;

var _border = 10;
var _current_y = items_box_title_y + items_box_title_h/2 + _border;
var _x = items_box_x - (sprite_get_width(spr_inventory_order) * GLOBAL_RES_SCALE*2)/2;

draw_set_halign(fa_middle);

var _hover = noone;
for (var i = 0; i < array_length(orders); ++i) {
	if ( point_in_rectangle(mouse_gui_x, mouse_gui_y, _x - _border - order_w/2, _current_y, _x + _border + order_w/2, _current_y + string_height(orders[i]) + _border) ) {
		_hover = i;
		if ( mouse_l ) {
			if ( selected_order == i ) {
				order_ascending = !order_ascending;
			} else {
				selected_order = i;
			}
		}
	}
	
	draw_set_color(_hover == i ? (c_black) : (c_gray));
	draw_rectangle(_x - _border - order_w/2, _current_y - _border, _x + _border + order_w/2, _current_y + string_height(orders[i]) + _border, false)
	
	draw_set_color(c_white);
    draw_text(_x, _current_y, orders[i]);
	_current_y += string_height(orders[i]) + _border;
}

if (_hover == noone && mouse_l) {
	focus = FOCUS.LIST;
	box_delay = 0;
}

}