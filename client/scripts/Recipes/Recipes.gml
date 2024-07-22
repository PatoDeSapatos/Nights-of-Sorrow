function Ingredient(_item_id, _quantity) constructor {
	item_id = _item_id;
	quantity = _quantity;
}

function Recipe(_ingredients, _result_id) constructor {
	ingredients = _ingredients;
	result_id = _result_id;
	
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

function add_recipe(_ingredients, _result_id) {
	struct_set(global.recipes, struct_names_count(global.recipes), new Recipe(_ingredients, _result_id));
}

function init_recipes() {
	add_recipe( [new Ingredient(0, 1), new Ingredient(2, 1)], 3 );
}