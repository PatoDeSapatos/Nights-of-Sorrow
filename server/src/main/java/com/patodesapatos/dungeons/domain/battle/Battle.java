package com.patodesapatos.dungeons.domain.battle;

import java.util.List;
import java.util.Arrays;

import com.patodesapatos.dungeons.domain.dungeon.Entity;

import lombok.Data;

@Data
public class Battle {
    private int id;
    private List<Entity> entities;

    public Battle(int id, Entity[] entities) {
        this.id = id;
        this.entities = Arrays.asList(entities);
    }

    public void add(Entity entity) {
        if (entity.getBattleId() != -1) return;
        if (entities.contains(entity)) return;

        entities.add(entity);
        entity.setBattleId(id);
    }
}
