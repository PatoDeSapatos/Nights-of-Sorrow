
function inventory_draw_recipes() {
	draw_items(recipes, true);
	
	if ( is_struct(active_item) && focus == FOCUS.ITEM ) {
		draw_set_color(c_white);
		var _selected_option = draw_item_options(bag_item_options.crafting.options);
		bag_item_options.crafting.action.take_action(_selected_option);
	}
	
	// Ingredients Box
	draw_set_color(c_black);
	draw_set_valign(fa_middle);
	
	var _current_y = ingredients_box_y + ingredients_border;
	for (var i = 0; i < array_length(recipe_ingredients); ++i) {
	    for (var j = 0; j < array_length(recipe_ingredients[i]); ++j) {
			var _ingredient = recipe_ingredients[i, j];
			var _item = get_item_by_id( _ingredient.item_id );
			var _xx = ingredients_box_x + (ingredient_w + ingredients_border)*j + ingredients_border + (sprite_get_width(spr_items)*ingredient_scale)/2;

			draw_set_halign(fa_left);
			draw_set_valign(fa_middle);
			draw_sprite_ext(spr_items, _item.sprId, _xx, _current_y, ingredient_scale, ingredient_scale, 0, c_white, 1);
			draw_text(_xx + ingredient_spr_w, _current_y, _item.display_name);
			
			draw_set_halign(fa_right);
			var _required_q = "/" +string(_ingredient.required_quantity);
			var _inventory_q = string(_ingredient.inventory_quantity);
			
			draw_text(_xx + ingredient_w - ingredients_border*2, _current_y, _required_q);
			
			draw_set_color( _ingredient.inventory_quantity >= _ingredient.required_quantity ? (c_green) : (c_red) );
			draw_text(_xx + ingredient_w - ingredients_border*2 - string_width(_required_q), _current_y, _inventory_q);
			draw_set_color(c_black);
		}
		_current_y += ingredient_h;
	}
}