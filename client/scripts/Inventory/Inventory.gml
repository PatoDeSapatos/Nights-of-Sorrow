function Item_Stack( _item_id, _quantity ) constructor {
	id = _item_id;
	quantity = _quantity;
}

function get_item_by_id(_item_id) {
	return ds_map_find_value(global.items, _item_id);
}

function inventory_add_item( _inventory, _item_id, _quantity ) {
	var _max_stack = get_item_by_id(_item_id).max_stack;
	var _item_in_inventory = false;
	if ( _quantity > _max_stack ) _quantity = _max_stack
	
	for (var i = 0; i < array_length(_inventory) ; ++i) {
	    if ( _inventory[i].id == _item_id ) {
			_inventory[i].quantity += _quantity;
			_item_in_inventory = true;
			
			if ( _inventory[i].quantity > _max_stack ) {
				_inventory[i].quantity = _max_stack;
			}
		}
	}
	
	if ( !_item_in_inventory ) {
		array_push(_inventory, new Item_Stack(_item_id, _quantity) );
	}
	

}

function inventory_remove_item( _inventory, _item_id, _quantity ) {
	for (var i = 0; i < array_length(_inventory); ++i) {
	    if(_inventory[i].id == _item_id) {
			_inventory[i].quantity -= _quantity;
			if (_inventory[i].quantity <= 0) {
				array_delete( _inventory, i, 1 );
			}
		}
	}
}