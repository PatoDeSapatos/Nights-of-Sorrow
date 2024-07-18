function Item(_name, _sprId, _max_stack = 999) constructor {
	name = _name;
	sprId = _sprId;
	max_stack = _max_stack;
}

function add_item( _name, _sprId ) {
	ds_map_add( global.items, array_length(global.items), new Item(_name, _sprId) );
}

function init_items() {
	add_item( "Bola de Slime", 0 );
	add_item( "Osso", 1 );
}