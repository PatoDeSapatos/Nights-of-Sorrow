package com.patodesapatos.dungeons.domain.dungeon;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;

public class InventoryDTO extends WebSocketDTO {
    
    public InventoryDTO(Entity entity) {
        super(MessageType.INVENTORY, null);

        if (entity != null) {
            packet.put("id", entity.getId());

            if (entity.getInventory() != null) {
                packet.put("data", entity.getInventory());
            }
        }
    }
}