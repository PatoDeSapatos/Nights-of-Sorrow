function generate_map() {
	random_set_seed(global.server.mapSeed + global.server.level)
	show_debug_message(global.server.mapSeed + global.server.level)

	load_map_images();
	map = generate_dungeon(, global.server.level)
	review_dungeon()
	cast_dungeon()
	radar = instance_create_layer(0, 0, "Instances", obj_radar)

	randomize()
}

global.loading = true;

// Server
depth = 10
global.server.send_websocket_message("DUNGEON_STATE", {invite: obj_server.dungeon_code});

// Camera
//global.camera.camera_w = 640;
//global.camera.camera_h = 360;
//global.res_scale = 1280/global.camera.camera_w;

// Dungeon Draw
scale = 1
tile_size = 32 * scale
roomSize = 32
roomSizeInPixels = tile_size * roomSize * 15
room_width = roomSizeInPixels
room_height = roomSizeInPixels
width = round(room_width / tile_size)
height = round(room_height / tile_size)

grid = ds_grid_create(width, height)
start_x = room_width / 2
start_y = room_height / 4
selected = -1
player_bottom = -1

ds_grid_set_region(grid, 0, 0, width, height, undefined)

// Dungeon Generation
entities = ds_map_create()
enemies_number = 1
map = -1

generate_map()

instance_create_layer(0, 0, "Instances", obj_dungeon_chat)
instance_create_layer(0, 0, "Instances", obj_inventory)

update_entities = function (_data) {
	var _entities = struct_get(_data, "entities");
	
	for (var i = 0; i < array_length(_entities); ++i) {
		if ( !is_struct(_entities[i]) ) {
			show_debug_message(_entities[i]);
			continue;
		}
		
		var _entity_id = struct_get(_entities[i], "id");
		
		if ( ds_map_exists(entities, _entity_id) ) {
			if (is_struct(struct_get(_entities[i], "data"))) {
				ds_map_find_value(entities, _entity_id).update_entity_values( struct_get(_entities[i], "data"), struct_get(_entities[i], "username"), struct_get(_entities[i], "level") );
			}
		} else {
			var _entity = instance_create_layer(map.initX, map.initY, "Instances", obj_player);
			var _username = struct_get(_entities[i], "username");
			
			_entity.player_username = _username;
			_entity.entity_id = _entity_id;
			ds_map_set(entities, _entity_id, _entity);	
			if ( global.server.username == _username ) {
				global.camera.follow = _entity;	
			}
		}
	}
}

function set_tile_entity(_id, _data) {
	var decoded_id = decode_tile_entity_id(_id)
	var tile_entity = grid[# decoded_id.x, decoded_id.y].get_stack_instance()
	tile_entity.set_data(_data)
}

function gen_tile_entity(_id) {
	random_set_seed(global.server.mapSeed + global.server.level)

	var decoded_id = decode_tile_entity_id(_id)
	var tile_entity = grid[# decoded_id.x, decoded_id.y].get_stack_instance()
	tile_entity.gen_data()

	var _data = {
		invite: global.server.dungeon_code,
		tileEntId: _id,
		data: tile_entity.data
	}
	global.server.send_websocket_message("ADD_TILE_ENTITY", _data)

	randomize()
}

global.loading = false;