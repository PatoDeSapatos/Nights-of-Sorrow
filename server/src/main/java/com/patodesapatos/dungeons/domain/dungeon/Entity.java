package com.patodesapatos.dungeons.domain.dungeon;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONPropertyIgnore;

import lombok.Data;

@Data
public class Entity implements Cloneable {
    private int id;
    private String userId;
    private String username;
    private int level;
    private JSONObject data;
    private JSONArray inventory;
    private int battleId;

    public Entity(Player player, int dungeonEntitiesId) {
        id = dungeonEntitiesId;
        userId = player.getUserId();
        username = player.getUsername();
        level = 1;
        battleId = -1;
    }

    public JSONObject toDTO() {
        var dto = new JSONObject(this);
        if (battleId == -1) dto.remove("battleId");
        return dto;
    }

    @JSONPropertyIgnore
    public String getUserId() {
        return userId;
    }

    @JSONPropertyIgnore
    public JSONArray getInventory() {
        return inventory;
    }
}