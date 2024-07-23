package com.patodesapatos.dungeons.domain.dungeon;

import org.json.JSONObject;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MapDTO extends WebSocketDTO {

    public MapDTO(JSONObject data) {
        super(MessageType.DUNGEON_ROOMS_SHARE, data);
    }

    public MapDTO(Dungeon dungeon) {
        this(new JSONObject().put("seed", dungeon.getMapSeed()));
    }
}