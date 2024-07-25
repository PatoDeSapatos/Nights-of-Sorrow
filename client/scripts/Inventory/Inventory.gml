function Item_Stack( _item_id, _quantity ) constructor {
	id = _item_id;
	quantity = _quantity;
}

function Recipe_Stack( _recipe_id ) constructor {
	id = _recipe_id;
	craftable = false;
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
		if ( point_in_rectangle(mouse_gui_x, mouse_gui_y, items_box_x - sprite_get_width(spr_inventory_order) * global.res_scale*2, items_box_title_y, items_box_x, items_box_title_y + items_box_title_h )) {
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
	
	var _order = noone;
	switch( selected_order ) {
		default: // Sort by type
			_order = sort_by_type;
			break;
		case ORDERS.QUANTITY:
			_order = sort_by_quantity;
			break;
		case ORDERS.NAME:
			_order = sort_by_name;
			break;
		case ORDERS.DATE: 
			_order = sort_by_date;
			break;
	}
	show_debug_message(selected_order)

	array_sort(_inventory_copy, _order);
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
	
		if (mouse_navigation && point_in_rectangle(mouse_gui_x, mouse_gui_y, items_box_x, items_box_name_y + _y - items_box_name_h/2, items_box_x + items_box_w, items_box_name_y + _y + items_box_name_h/2)) {
			selected_item = i;
		}
	
		if ( selected_item == i ) {
			draw_sprite_stretched(spr_selected_item_border, 0, 0, _y - items_box_name_h/2 - items_box_border/4, items_box_w, items_box_name_h + items_box_border/2 );
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
		
	selected_item += down_input - up_input;
	selected_item = clamp(selected_item, 0, array_length(_inventory_copy) - 1);
	
	if ( focus == FOCUS.ORDER ) {
		draw_order_box();
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
	
	update_recipes();
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
	update_recipes();
}

function inventory_add_recipe(_recipes_index, _recipe_id) {
	array_push(_recipes_index, new Recipe_Stack( _recipe_id ));
	update_recipes();
}

function update_recipes() {
	array_foreach(recipes, function(_value, _index) {
		var _recipe = get_recipe_by_id(_value.id);
		_value.craftable = _recipe.can_craft(inventory);
	});
	
	for (var i = 0; i < array_length(recipe_ingredients); ++i) {
	    for (var j = 0; j < array_length(recipe_ingredients[i]); ++j) {
		    recipe_ingredients[i, j].update_quantity(inventory);
		}
	}
}