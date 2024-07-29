/// @description
if ( !inventory_open ) return;
var _prev_item = selected_item;

// Inventory Tabs
var _tab_w = sprite_get_width(spr_inventory_tabs) * global.res_scale*2;
var _tab_h = sprite_get_height(spr_inventory_tabs) * global.res_scale*2;

for (var i = sprite_get_number(spr_inventory_tabs) - 1; i >= 0; --i) {
	if ( i == selected_tab ) continue;
	draw_sprite_ext(spr_inventory_tabs, i, items_box_x, tabs_y[i], global.res_scale*2, global.res_scale*2, 0, c_white, 1);
	
	if ( (focus == FOCUS.LIST || focus == FOCUS.ITEM) && mouse_l && point_in_rectangle(mouse_gui_x, mouse_gui_y, items_box_x - _tab_w, tabs_y[i] + global.res_scale*6, items_box_x, tabs_y[i] + _tab_h - global.res_scale*3) ) {
		focus = FOCUS.LIST;
		selected_tab = i;
	}	
}

draw_set_color(c_white);
draw_rectangle( 
	items_box_x,
	items_box_y,
	items_box_x + items_box_w,
	items_box_y + items_box_h,
	false
);

switch ( selected_tab ) {
	case TABS.ITEMS:
		inventory_draw_items();
		break;
	case TABS.CRAFTING:
		inventory_draw_recipes();
		break;
}

draw_sprite_stretched(spr_inventory_bg, 0, items_box_x, items_box_y, items_box_w + global.res_scale, items_box_h);
if ( selected_tab == TABS.CRAFTING ) draw_sprite_stretched(spr_inventory_bg, 0, items_box_x - global.res_scale, ingredients_box_y - ingredients_border, items_box_w + global.res_scale, ingredients_box_h + ingredients_border);

// Selected Tab
draw_sprite_ext(spr_inventory_tabs, selected_tab, items_box_x, tabs_y[selected_tab], global.res_scale*2, global.res_scale*2, 0, c_ltgray, 1);

// Panels
if ( focus == FOCUS.ITEM_PANEL ) {
	draw_item_quantity_panel();
}
	
if ( focus == FOCUS.ORDER ) {
	draw_order_box();
}

if ( _prev_item != selected_item ) {
	get_recipe_ingredients();
}