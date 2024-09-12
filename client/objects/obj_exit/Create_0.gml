collided = false

interaction = function () {
	if (collided) return

	global.server.send_websocket_message("CHANGE_LEVEL", {
		invite: global.server.dungeon_code,
		entityId: other.entity_id,
		level: global.server.level + 1
	})

	collided = true
}