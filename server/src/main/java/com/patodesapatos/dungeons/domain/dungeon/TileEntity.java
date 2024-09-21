package com.patodesapatos.dungeons.domain.dungeon;

import org.json.JSONObject;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class TileEntity {
    private String id;
    private JSONObject data;
}
