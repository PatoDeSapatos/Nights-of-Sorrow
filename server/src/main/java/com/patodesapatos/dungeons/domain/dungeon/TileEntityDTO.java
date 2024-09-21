package com.patodesapatos.dungeons.domain.dungeon;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;

public class TileEntityDTO extends WebSocketDTO {

    public TileEntityDTO(String id, TileEntity tileEntity) {
        super(MessageType.TILE_ENTITY, null);

        packet.put("id", id);

        if (tileEntity != null) {
            packet.put("data", tileEntity.getData());
        }
    }
}