package com.patodesapatos.dungeons.domain.dungeon;

import java.util.ArrayList;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;

public class DungeonDTO extends WebSocketDTO {
    private Dungeon dungeon;

    public DungeonDTO(Dungeon dungeon, int level) {
        super(MessageType.DUNGEON_STATE);
        this.dungeon = dungeon;

        var parsedEntities = new ArrayList<Entity>();
        for (int i = 0; i < dungeon.getEntities().size(); i++) {
            var entity = dungeon.getEntities().get(i);
            var player = dungeon.getPlayerByUsername(entity.getUsername());

            if (player != null && player.isOnline()) {
                if (level < 0 && entity.getLevel() == level) parsedEntities.add(entity.toDTO());
            }
        }

        getData().put("entities", parsedEntities);
    }

    public Dungeon getDungeon() {
        return dungeon;
    }

    public void setJoinPacket() {
        getData().put("joinPacket", true);
    }
}
