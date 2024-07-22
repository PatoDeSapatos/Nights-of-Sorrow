function Ingredient(_item_name, _quantity) constructor {
	item_id = get_item_id_by_name( _item_name );
	quantity = _quantity;
}

function Recipe(_ingredients, _result_name) constructor {
	ingredients = _ingredients;
	result_id = get_item_id_by_name( _result_name );
	
	function can_craft(_inventory) {
		for (var i = 0; i < array_length(ingredients); ++i) {
			var _ingredient = ingredients[i];
			var _quantity = _ingredient.quantity;
			
		    for (var j = 0; j < array_length(_inventory); ++j) {
				var _inv_item = _inventory[j];
				
				if ( _inv_item.id == _ingredient.item_id ) {
					_quantity -= _inv_item.quantity;
				}
			}
		}
		
		if ( _quantity <= 0 ) return true;
		return false;
	}
}

function add_recipe(_ingredients, _result_name) {
	struct_set(global.recipes, struct_names_count(global.recipes), new Recipe(_ingredients, _result_name));
}

function init_recipes() {
	add_recipe( [new Ingredient("SLIME_BALL", 1), new Ingredient("MAD_HAMMER", 1)], "STICKY_HAMMER" );
}