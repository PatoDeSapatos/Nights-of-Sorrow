function inventory_draw_items() {
// Items List
draw_items(inventory, false);

if (is_struct( active_item )) {
	if ( focus == FOCUS.ITEM ) {
		var _item_info = get_item_by_id( active_item.id );
		var _item_options = noone;
		var _selected_option = -1;
	
		if ( is_instanceof(_item_info, Material_Item) ) {
			_item_options = bag_item_options.material;
		} else if ( is_instanceof(_item_info, Equipment_Item) ) {
			_item_options = bag_item_options.equipment;
		} else if ( is_instanceof(_item_info, Consumable_Item) ) {
			_item_options = bag_item_options.consumable; 
		}
	
		_selected_option = draw_item_options(_item_options.options);
		_item_options.action.take_action(_selected_option);
	}
}

var _changed_category = selected_category;
selected_category += right_input - left_input;
selected_category = clamp(selected_category, 0, ItemCategory.LENGTH - 1);
if ( _changed_category != selected_category ) {
	selected_item = 0;	
}
}

function draw_item_options(_options) {
	var _current_y = active_item_y;
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	for (var i = 0; i < array_length(_options); ++i) {
		var _x = items_box_x + items_box_w + ingredients_border;
		
	    draw_text(_x, _current_y, _options[i]);
		if (mouse_l && point_in_rectangle(mouse_gui_x, mouse_gui_y, _x, _current_y, _x + string_width(_options[i]), _current_y + string_height(_options[i])) ) {
			return i;
		}
		
		_current_y += string_height(_options[i]);
	}
}

function show_discard_panel(_item) {
	focus = FOCUS.ITEM_PANEL;
	var _parameters = {
		item_id: _item.id,
		quantity: 1
	}
	
	discard_panel.update(_item.id, _parameters)
	active_panel = discard_panel;
}