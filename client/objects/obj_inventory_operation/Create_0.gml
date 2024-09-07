/// @description 
items = [];
waiting_time = 2*FRAME_RATE;

add_item = function(_item_id, _quantity, _type) {
	var _name = get_item_by_id(_item_id).display_name;
	var _index = -1;
	
	for (var i = 0; i < array_length(items); ++i) {
	    if (items[i, 0] == _name && items[i, 2] == _type) {
			_index = i;
			break;
		}
	}
	
	alarm[0] = waiting_time;
	
	if (_index != -1) {
		items[_index, 1] += _quantity;
		return;
	}
	
	var _color;
	
	switch(_type) {
		case "Added":
			_color = c_lime;
			break;
		case "Removed":
			_color = c_red;
			break;
		case "Consumed":
			_color = c_yellow;			
			break;
		default:
			_color = c_white;
			break;
	}
	
	array_push(items, [_name, _quantity, _type, _color]);
}