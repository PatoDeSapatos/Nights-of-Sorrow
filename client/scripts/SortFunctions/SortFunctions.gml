function sort_by_type(_item1, _item2) {
	if (_item1 == undefined || _item2 == undefined) return -1;
	return (get_item_by_id(_item1.id).category - get_item_by_id(_item2.id).category)*(order_ascending ? (1) : (-1));
}

function sort_by_name(_item1, _item2) {
	if (_item1 == undefined || _item2 == undefined) return -1;
	var _left = get_item_by_id(_item1.id);
	var _right = get_item_by_id(_item2.id);
	var _order = (order_ascending ? (1) : (-1));
	
	 if (_left.display_name < _right.display_name)
        return -1*_order;
    else if (_left.display_name > _right.display_name)
        return 1*_order;
    else
        return 0;	
}

function sort_by_quantity(_item1, _item2) {
	if (_item1 == undefined || _item2 == undefined) return -1;
	return (_item1.quantity - _item2.quantity)*(order_ascending ? (1) : (-1));
}

function sort_by_date(_item1, _item2) {
	if (_item1 == undefined || _item2 == undefined) return -1;
	return order_ascending ? (1) : (-1);
}

function inventory_sort(_item1, _item2) {
	if ( (_item1 != undefined || _item2 != undefined) && (_item1.id == _item2.id) ) {
		return _item2.quantity - _item1.quantity;
	}
	return sort(_item1, _item2);
}