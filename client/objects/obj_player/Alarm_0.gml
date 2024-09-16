if (player_username != global.server.username) return

var _data = {};
var _entity_data = {
	x: round(x),
	y: round(y),
	sprites: sprites,
	sprite_index: sprite_index,
	image_index: image_index,
	facing_right: facing_right,
	facing_up: facing_up
};
	
struct_set(_data, "invite", global.server.dungeon_code);
struct_set(_data, "entityId", entity_id);
struct_set(_data, "data", _entity_data);

global.server.send_websocket_message("UPDATE_ENTITY", _data);

alarm[0] = 3
