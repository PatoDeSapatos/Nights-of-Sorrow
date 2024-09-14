package com.patodesapatos.dungeons.domain.dungeon;

import org.json.JSONObject;

import lombok.Data;

@Data
public class Entity implements Cloneable {
    private int id;
    private String userId;
    private String username;
    private int level;
    private JSONObject data;

    public Entity(Player player, int dungeonEntitiesId) {
        id = dungeonEntitiesId;
        userId = player.getUserId();
        username = player.getUsername();
        level = 1;
    }

    public Entity toDTO() {
        try {
            var dto = (Entity) clone();
            dto.setUserId(null);
            return dto;
        } catch (Exception e) {
            System.err.println("Entity clone not supported.");
            return null;
        }
    }
}