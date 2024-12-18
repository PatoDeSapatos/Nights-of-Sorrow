package com.patodesapatos.dungeons.domain.dungeon.dto;

import java.util.ArrayList;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;
import com.patodesapatos.dungeons.domain.dungeon.Dungeon;
import com.patodesapatos.dungeons.domain.dungeon.Entity;

public class DungeonDTO extends WebSocketDTO {
    private Dungeon dungeon;

    public DungeonDTO(Dungeon dungeon, Entity reqEntity) {
        super(MessageType.DUNGEON_STATE);
        this.dungeon = dungeon;

        int level = -1;
        if (reqEntity != null) {
            level = reqEntity.getLevel();
        }

        var parsedEntities = new ArrayList<Entity>();
        for (int i = 0; i < dungeon.getEntities().size(); i++) {
            var entity = dungeon.getEntities().get(i);
            var player = dungeon.getPlayerByUsername(entity.getUsername());

            if (player != null && player.isOnline()) {
                if (level > -1 && entity.getLevel() != level) continue;
                parsedEntities.add(entity.toDTO());
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
