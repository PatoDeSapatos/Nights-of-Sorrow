/// @description Insert description here
event_inherited();

draw_set_halign(fa_center);
draw_set_valign(fa_center);
draw_set_color(c_black);
var _fnt = draw_get_font();
draw_set_font(fnt_inventory_title)
draw_text(items_box_x + items_box_w/2, items_box_y + (items_box_title_y - items_box_y)/2, "Chest")
draw_set_font(_fnt);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

