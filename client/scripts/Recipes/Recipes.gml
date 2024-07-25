function Ingredient(_item_name, _quantity) constructor {
	item_id = get_item_id_by_name( _item_name );
	quantity = _quantity;
}

function Recipe(_ingredients, _result_name, _result_quantity) constructor {
	ingredients = _ingredients;
	result_id = get_item_id_by_name( _result_name );
	result_quantity = _result_quantity;
	
	function can_craft(_inventory) {
		var _quantity = [];
		for (var i = 0; i < array_length(ingredients); ++i) {
			var _ingredient = ingredients[i];
			_quantity[i] = _ingredient.quantity;
			
		    for (var j = 0; j < array_length(_inventory); ++j) {
				var _inv_item = _inventory[j];
				
				if ( _inv_item.id == _ingredient.item_id ) {
					_quantity[i] -= _inv_item.quantity;
				}
			}
		}
		
		var _final_quantity = array_reduce(_quantity, function (_prev, _curr) {
			return max(_prev, 0) + max(_curr, 0);
		});
		if ( _final_quantity <= 0 ) return true;
		return false;
	}
}

function get_recipe_by_id(_recipe_id) {
	return struct_get( global.recipes, _recipe_id );
}

function add_recipe(_ingredients, _result_name, _result_quantity) {
	struct_set(global.recipes, struct_names_count(global.recipes), new Recipe(_ingredients, _result_name, _result_quantity));
}

function init_recipes() {
	add_recipe( [new Ingredient("SLIME_BALL", 1), new Ingredient("MAD_HAMMER", 1)], "STICKY_HAMMER", 1 );
}