function Item_Stack( _item_id, _quantity ) constructor {
	id = _item_id;
	quantity = _quantity;
}

function Recipe_Stack( _recipe_id ) constructor {
	id = _recipe_id;
	craftable = false;
}

function Item_Quantity_Panel(_x, _y, _title, _button_name, _onclick, _onclick_parameters) constructor {
	x = _x;
	y = _y;
	w = 0;
	h = 0;
	border = 20;
	title_h = 0;
	title = _title;
	quantity = 1;
	quantity_typing = 1;
	quantity_h = string_height("0") + border/4;
	button_name = _button_name;
	button_w = 0;
	onclick = _onclick;
	onclick_parameters = _onclick_parameters;
	item = -1;
	
	onclick_handler = function(_click) {
		if (_click) {
			onclick(onclick_parameters);	
		}
	}
	
	update = function(_item, _onclick_parameters) {
		item = _item;
		onclick_parameters = _onclick_parameters;
	
		button_w = max( string_width(button_name) + border*2, string_width("Cancel") + border*2 );
		w = button_w * 2 + border*3;
		
		title_h = string_height_ext(title, 1, w);
		h = title_h + quantity_h + string_height(button_name);
	}
	
	update(item, onclick_parameters);
}

function Ingredient_Stack(_item_id, _required_quantity) constructor {
	item_id = _item_id;
	required_quantity = _required_quantity;
	inventory_quantity = 0;
	
	function update_quantity(_inventory) {
		var _inv_quantity = 0;
		
		for (var i = 0; i < array_length(_inventory); ++i) {
		    if ( _inventory[i].id == item_id ) {
				_inv_quantity += _inventory[i].quantity;
			}
		}
		
		inventory_quantity = _inv_quantity;
	}
	
	update_quantity(obj_inventory.inventory)
}

function get_item_by_id(_item_id) {
	return struct_get(global.items, _item_id);
}

function get_item_id_by_name(_item_name) {
	var _item_id = noone;
	
	var _item_ids = struct_get_names(global.items);
	for (var i = 0; i < array_length(_item_ids); ++i) {
		var _item = struct_get( global.items, _item_ids[i]);
	    if (  _item.name == _item_name ) {
			_item_id = _item_ids[i]
			break;
		}
	}
	
	return _item_id;
}

function draw_items(_inventory, _is_recipe) {
	// Order Tab
	draw_sprite_ext(spr_inventory_order, 0, items_box_x, items_box_title_y, global.res_scale*2, (items_box_title_h+global.res_scale) / sprite_get_height(spr_inventory_order), 0, c_yellow, 1);
	
	// Order
	if ( mouse_l ) {
		if ( (focus == FOCUS.LIST || focus == FOCUS.ITEM) && point_in_rectangle(mouse_gui_x, mouse_gui_y, items_box_x - sprite_get_width(spr_inventory_order) * global.res_scale*2, items_box_title_y, items_box_x, items_box_title_y + items_box_title_h )) {
			focus = FOCUS.ORDER;
		}
	}
	
	// Items Categories
	var _categories_space = sprite_get_width(spr_items_categories)*global.res_scale*2.5 + items_box_border/4
	var _categories_w = items_box_border + _categories_space*ItemCategory.LENGTH;
	for (var i = 0; i < ItemCategory.LENGTH; ++i) {
		var _icon_w = sprite_get_width(spr_items_categories)*global.res_scale*2.5;
		var _icon_h = sprite_get_height(spr_items_categories)*global.res_scale*2.5;
		var _icon_x = items_box_x + items_box_w/2 - _categories_w/4 + _categories_space*i;
		var _icon_y = (items_box_category_h + items_box_border)/2;
	
		if ((focus == FOCUS.LIST || focus == FOCUS.ITEM) && mouse_l && point_in_rectangle(mouse_gui_x, mouse_gui_y, _icon_x - _icon_w/2, _icon_y - _icon_h/2, _icon_x + _icon_w/2, _icon_y + _icon_h/2)) {
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
	
	if ( !surface_exists(items_box_list_surf) ) {
		items_box_list_surf = surface_create(items_box_w, items_box_h);	
	}

	draw_set_color(c_black);
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);

	surface_set_target(items_box_list_surf);
	draw_clear_alpha(c_black, 0);

	var _inventory_copy = [];
	array_copy(_inventory_copy, 0, _inventory, 0, array_length(_inventory));

	if ( selected_category != ItemCategory.DEFAULT ) {
		if ( _is_recipe ) {
			_inventory_copy = array_filter(_inventory_copy, function (_element, _index) {
				var _result_item_id = get_recipe_by_id( _element.id ).result_id;
				return get_item_by_id( _result_item_id ).category == selected_category;
			});
		} else {
			_inventory_copy = array_filter(_inventory_copy, function (_element, _index) {
				return get_item_by_id( _element.id ).category == selected_category;
			});
		}
	}
	
	switch( selected_order ) {
		default: // Sort by type
			sort = sort_by_type;
			break;
		case ORDERS.QUANTITY:
			sort = sort_by_quantity;
			break;
		case ORDERS.NAME:
			sort = sort_by_name;
			break;
		case ORDERS.DATE: 
			sort = sort_by_date;
			break;
	}

	array_sort(_inventory_copy, inventory_sort);
	var _current_y = items_box_name_offset;
	for (var i = 0; i < array_length(_inventory_copy); ++i) {
		var _y = _current_y + items_box_name_h/2 + items_box_border/2;
		
		if ( !_is_recipe ) {
			var _item = get_item_by_id( _inventory_copy[i].id );	
			var _quantity = _inventory_copy[i].quantity;
			
			// Item Quantity
			draw_set_halign(fa_center);
			draw_text( items_box_quantity_x, _y, _quantity );
		} else {
			var _item = get_item_by_id( get_recipe_by_id( _inventory_copy[i].id ).result_id );
			var _craftable = _inventory_copy[i].craftable;
		}
	
		var _mouse_hover = mouse_navigation && point_in_rectangle(mouse_gui_x, mouse_gui_y, items_box_x, items_box_name_y + _y - items_box_name_h/2, items_box_x + items_box_w, items_box_name_y + _y + items_box_name_h/2);
	
		if (_mouse_hover) {
			selected_item = i;
		}
	
		if ( (focus == FOCUS.LIST || focus == FOCUS.ITEM) && selected_item == i ) {
			draw_sprite_stretched(spr_selected_item_border, 0, 0, _y - items_box_name_h/2 - items_box_border/4, items_box_w, items_box_name_h + items_box_border/2 );
			if ( (focus == FOCUS.LIST || focus == FOCUS.ORDER || focus == FOCUS.ITEM) && (_mouse_hover && mouse_l) || (confirm_input) ) {
				active_item = _inventory_copy[i];
				focus = FOCUS.ITEM;	
			}
		}
		
		if (_inventory_copy[i] == active_item) {
			active_item_y = _y + items_box_name_y - items_box_name_h/2;	
		}
	
		// Item Image
		draw_sprite_ext( spr_items, _item.sprId, items_box_name_x - items_box_spr_size, _y, global.res_scale * 2, global.res_scale * 2, 0, c_white, 1 );
	
		// Item Name
		if ( _is_recipe ) {
			draw_set_color( _craftable ? (c_green) : (c_red) );
		}
		
		draw_set_halign(fa_left);
		draw_text( items_box_name_x, _y, _item.display_name );
		draw_set_color(c_black);
	
		// Item Category
		draw_sprite_ext( spr_items_categories, _item.category, items_box_category_x, _y, global.res_scale * 2, global.res_scale * 2, 0, c_white, 1 );
	
		_current_y += items_box_name_h + items_box_border/3;
	}

	draw_set_valign(fa_top);
	draw_set_color(c_white);

	surface_reset_target();
	draw_surface(items_box_list_surf, items_box_x, items_box_name_y);
	
	if (focus == FOCUS.LIST) {
		selected_item += down_input - up_input;
		box_delay = 0;
	}
	selected_item = clamp(selected_item, 0, array_length(_inventory_copy) - 1);
}

function draw_item_quantity_panel() {
	draw_set_color(c_black);
	draw_set_alpha(.7);
	draw_rectangle(0, 0, gui_w, gui_h, false);
	draw_set_alpha(1);
	var _x = active_panel.x;
	var _y = active_panel.y;
	var _w = active_panel.w;
	var _h = active_panel.h;
	var _quantity = string(active_panel.quantity_typing);
	var _quantity_w = string_width("999") + active_panel.border/2;
	var _quantity_h = active_panel.quantity_h;
	var _quantity_x = _x - _quantity_w/2;
	var _quantity_y = _y - _h/2 + active_panel.title_h;
	var _button_x = _x - _w/2 + active_panel.border;
	var _button_y = _y + _h - active_panel.border;
	var _button_x2 = _button_x + active_panel.button_w + active_panel.border;

	draw_set_color(c_white);
	draw_roundrect_ext(_x - _w/2, _y - _h - active_panel.border, _x + _w/2, _y + _h + active_panel.border, 14, 14, false);

	draw_set_halign(fa_middle);
	draw_set_valign(fa_middle);
	draw_set_color(c_black);
	draw_text_ext(_x, _y - _h + active_panel.border, active_panel.title, 1, _w);
	draw_set_color(c_gray);
	draw_rectangle(_quantity_x, _quantity_y, _quantity_x + _quantity_w, _quantity_y + _quantity_h, false);
	draw_set_color(c_white);
	draw_text(_quantity_x + _quantity_w/2, + _quantity_y + _quantity_h/2, _quantity);
	
	if ( typing ) {
		if ( keyboard_check_pressed(vk_anykey) ) {
			if ( keyboard_lastkey != vk_backspace ) {
				var _number = 0;
				try {
					_number = string(active_panel.quantity_typing) + string(keyboard_lastchar);
					if(string_length(_number) <= 3) active_panel.quantity_typing = floor(real(_number));
				} catch(e) {
					show_debug_message(e);	
				}
			} else {
				active_panel.quantity_typing = string_delete(_quantity, string_length(_quantity), 1);
			}
		}
		
		if (typing_bar) draw_line(_quantity_x + (string_width(_quantity) + _quantity_w)/2 + 2, _quantity_y + _quantity_h/2 - string_height(_quantity)/2 + 5, _quantity_x + (string_width(_quantity) + _quantity_w)/2 + 2, _quantity_y + _quantity_h/2 + string_height(_quantity)/2 - 5);
		
		if (alarm[0] <= 0 && alarm[1] <= 0) {
			alarm[0] = 10;
		}
	}
	
	if ( mouse_l ) {
		if ( !point_in_rectangle(mouse_gui_x, mouse_gui_y, _quantity_x, _quantity_y, _quantity_x + _quantity_w, _quantity_y + _quantity_h) ) {
			typing = false
			if ( is_instanceof(active_panel.item, Item_Stack) ) {
				active_panel.quantity = clamp(string_length(_quantity) > 0 ? (real(_quantity)) : (1), 1, active_panel.item.quantity);
			} else {
				active_panel.quantity = clamp(string_length(_quantity) > 0 ? (real(_quantity)) : (1), 1, 999);
			}
			active_panel.quantity_typing = active_panel.quantity;
		} else {
			typing = true;	
		}
	}
	
	draw_panel_button(_button_x, _button_y, _button_x + active_panel.button_w, _button_y + string_height(active_panel.button_name), active_panel.button_name, spr_inventory_panel_button, active_panel.onclick, active_panel.onclick_parameters);
	draw_panel_button(_button_x2, _button_y, _button_x2 + active_panel.button_w, _button_y + string_height(active_panel.button_name), "Cancel", spr_inventory_panel_button, function () { focus = FOCUS.LIST } );
}

function draw_panel_button(_x1, _y1, _x2, _y2, _text, _spr, _onclick, _onclick_parameters = {}) {
	var _hover = point_in_rectangle(mouse_gui_x, mouse_gui_y, _x1, _y1, _x2, _y2);
	var _active = _hover && mouse_l;
	var _w = _x2 - _x1;
	var _h = _y2 - _y1;
	
	draw_sprite_stretched_ext(_spr, _hover + _active, _x1, _y1, _w, _h, c_white, 1);
	draw_set_halign(fa_middle);
	draw_set_valign(fa_middle);
	draw_text(_x1 + _w/2, _y1 + _h/2, _text);
	if (_active) {
		_onclick(_onclick_parameters);	
	}
}

function get_recipe_ingredients() {
	if ( selected_tab == TABS.CRAFTING && selected_item >= 0 && array_length(recipes) >= selected_item ) {
		var _recipe = get_recipe_by_id( recipes[selected_item].id );
		var _ingredients = _recipe.ingredients;
	
		for (var i = 0; i < array_length(_ingredients); ++i) {
		    recipe_ingredients[i - i % ingredients_cols, i % ingredients_cols] = new Ingredient_Stack( _ingredients[i].item_id, _ingredients[i].quantity );
		}
	}	
}

function inventory_add_item( _inventory, _item_id, _quantity ) {
	var _max_stack = get_item_by_id(_item_id).max_stack;
	var _item_in_inventory = false;
	var _excess = 0;
	
	for (var i = 0; i < array_length(_inventory) ; ++i) {
	    if ( _inventory[i].id == _item_id ) {
			var _final_quantity = _inventory[i].quantity + _quantity;
			
			if ( _inventory[i].quantity == _max_stack ) {
				continue;
			} else if ( _final_quantity > _max_stack ) {
				_inventory[i].quantity = _max_stack;
				_excess = _final_quantity - _max_stack;
				continue;
			}
			
			if ( _excess <= 0 ) {
				_inventory[i].quantity += _quantity;
				_item_in_inventory = true;
			} else {
				_inventory[i].quantity += _excess;
				break;
			}
		}
	}
	
	if ( !_item_in_inventory ) {
		array_push(_inventory, new Item_Stack(
			_item_id, 
			_excess > 0 ? (_excess) : (_quantity)
		));
	}
	
	update_inventory();
}

function inventory_remove_item( _inventory, _item_id, _quantity ) {
	for (var i = 0; i < array_length(_inventory); ++i) {
	    if(_inventory[i].id == _item_id) {
			_inventory[i].quantity -= _quantity;
			if (_inventory[i].quantity <= 0) {
				array_delete( _inventory, i, 1 );
			}
			break;
		}
	}
	update_inventory();
}

function inventory_merge_items(_inventory) {
	for (var i = 0; i < array_length(_inventory); ++i) {
	    var _item = _inventory[i];
		var _max_stack = get_item_by_id(_item.id).max_stack;
		var _quantity = _item.quantity;
		if ( _item.quantity >= _max_stack ) continue;
		
		for (var j = 0; j < array_length(_inventory); ++j) {
		    if (i == j) continue;
			var _checking_stack = _inventory[j];
			if ( _checking_stack.id == _item.id && _checking_stack.quantity < _max_stack ) {
				var _space = get_item_by_id(_checking_stack.id).max_stack - _checking_stack.quantity;
				_checking_stack.quantity += _space;
				_quantity -= _space;
				_inventory[i].quantity = _quantity;
				if (_quantity <= 0) { 
					array_delete(_inventory, i, 1);
					break;
				}
			}
		}
	}	
}

function inventory_add_recipe(_recipes_index, _recipe_id) {
	array_push(_recipes_index, new Recipe_Stack( _recipe_id ));
	update_inventory();
}

function inventory_craft_recipe(_recipes_index, _recipe) {
	if ( !_recipe.craftable ) return;
	
	var _recipe_data = get_recipe_by_id(_recipe.id);
	for (var i = 0; i < array_length(_recipe_data.ingredients); ++i) {
	    var _ingredient = _recipe_data.ingredients[i];
		inventory_remove_item(inventory, _ingredient.item_id, _ingredient.quantity);
	}
	inventory_add_item(inventory, _recipe_data.result_id, _recipe_data.result_quantity);
}

function inventory_craft_recipe_all(_recipes_index, _recipe) {
	while( _recipe.craftable )	{
		inventory_craft_recipe(_recipes_index, _recipe);	
	}
}

function update_inventory() {
	array_foreach(recipes, function(_value, _index) {
		var _recipe = get_recipe_by_id(_value.id);
		_value.craftable = _recipe.can_craft(inventory);
	});
	
	for (var i = 0; i < array_length(recipe_ingredients); ++i) {
	    for (var j = 0; j < array_length(recipe_ingredients[i]); ++j) {
		    recipe_ingredients[i, j].update_quantity(inventory);
		}
	}
	
	inventory_merge_items(inventory);
}