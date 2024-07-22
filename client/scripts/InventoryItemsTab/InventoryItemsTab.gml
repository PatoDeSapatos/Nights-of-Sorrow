function inventory_draw_items() {
// Order Tab
draw_sprite_ext(spr_inventory_order, 0, items_box_x, items_box_title_y, global.res_scale*2, (items_box_title_h+global.res_scale) / sprite_get_height(spr_inventory_order), 0, c_yellow, 1);
	
// Items Categories
var _categories_space = sprite_get_width(spr_items_categories)*global.res_scale*2.5 + items_box_border/4
var _categories_w = items_box_border + _categories_space*ItemCategory.LENGTH;
for (var i = 0; i < ItemCategory.LENGTH; ++i) {
	var _icon_w = sprite_get_width(spr_items_categories)*global.res_scale*2.5;
	var _icon_h = sprite_get_height(spr_items_categories)*global.res_scale*2.5;
	var _icon_x = items_box_x + items_box_w/2 - _categories_w/4 + _categories_space*i;
	var _icon_y = (items_box_category_h + items_box_border)/2;
	
	if (mouse_l && point_in_rectangle(mouse_gui_x, mouse_gui_y, _icon_x - _icon_w/2, _icon_y - _icon_h/2, _icon_x + _icon_w/2, _icon_y + _icon_h/2)) {
		selected_category = i;
	}
	
	var _alpha = selected_category == i ? (1) : (.5);
    draw_sprite_ext(spr_items_categories, i, _icon_x, _icon_y, global.res_scale*2.5, global.res_scale*2.5, 0, c_white, _alpha);
}

// Items Title
draw_set_color(c_yellow);

draw_rectangle(items_box_x, items_box_title_y, items_box_x + items_box_w, items_box_title_y + items_box_title_h, false)

draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(c_black);
draw_text(items_box_x + items_box_name_x, items_box_title_y + items_box_title_h/2, "Name");

draw_set_halign(fa_center);
draw_text(items_box_x + items_box_quantity_x, items_box_title_y + items_box_title_h/2, "Qtd");
draw_text(items_box_x + items_box_category_x, items_box_title_y + items_box_title_h/2, "Category");

// Items List
if ( !surface_exists(items_box_list_surf) ) {
	items_box_list_surf = surface_create(items_box_w, items_box_h);	
}
surface_set_target(items_box_list_surf);
draw_clear_alpha(c_black, 0);

var _inventory_copy = [];
array_copy(_inventory_copy, 0, inventory, 0, array_length(inventory));

if ( selected_category != ItemCategory.DEFAULT ) {
	_inventory_copy = array_filter(_inventory_copy, function (_element, _index) {
		return get_item_by_id( _element.id ).category == selected_category;
	});
}

var _current_y = items_box_name_offset;
for (var i = 0; i < array_length(_inventory_copy); ++i) {
	var _item = get_item_by_id( _inventory_copy[i].id );
	var _quantity = _inventory_copy[i].quantity;
	var _y = _current_y + items_box_name_h/2 + items_box_border/2;
	
	if (mouse_navigation && point_in_rectangle(mouse_gui_x, mouse_gui_y, items_box_x, items_box_name_y + _y - items_box_name_h/2, items_box_x + items_box_w, items_box_name_y + _y + items_box_name_h/2)) {
		selected_item = i;
	}
	
	if ( selected_item == i ) {
		draw_sprite_stretched(spr_selected_item_border, 0, 0, _y - items_box_name_h/2 - items_box_border/4, items_box_w, items_box_name_h + items_box_border/2 );
	}
	
	// Item Image
	draw_sprite_ext( spr_items, _item.sprId, items_box_name_x - items_box_spr_size, _y, global.res_scale * 2, global.res_scale * 2, 0, c_white, 1 );
	
	// Item Name
	draw_set_halign(fa_left);
    draw_text( items_box_name_x, _y, _item.display_name );
	
	// Item Quantity
	draw_set_halign(fa_center);
	draw_text( items_box_quantity_x, _y, _quantity );
	
	// Item Category
	draw_sprite_ext( spr_items_categories, _item.category, items_box_category_x, _y, global.res_scale * 2, global.res_scale * 2, 0, c_white, 1 );
	
	_current_y += items_box_name_h + items_box_border/3;
}

draw_set_valign(fa_top);
draw_set_color(c_white);

surface_reset_target();
draw_surface(items_box_list_surf, items_box_x, items_box_name_y);

selected_item += down_input - up_input;
selected_item = clamp(selected_item, 0, array_length(_inventory_copy) - 1);

var _changed_category = selected_category;
selected_category += right_input - left_input;
selected_category = clamp(selected_category, 0, ItemCategory.LENGTH - 1);
if ( _changed_category != selected_category ) {
	selected_item = 0;	
}	
}