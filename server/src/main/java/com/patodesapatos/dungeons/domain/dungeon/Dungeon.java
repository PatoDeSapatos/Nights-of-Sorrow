package com.patodesapatos.dungeons.domain.dungeon;

import java.util.ArrayList;
import java.util.UUID;

import org.apache.commons.lang3.RandomStringUtils;
import org.json.JSONObject;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
@AllArgsConstructor
public class Dungeon {
    private String id;
    private ArrayList<Player> players;
    private ArrayList<Entity> entities;
    private ArrayList<TileEntity> tileEntities;
    private int entitiesId;
    private String admUsername;
    private String invite;
    private boolean isPublic;
    private boolean started;
    private long mapSeed;

    public Dungeon(Player player) {
        this.id = UUID.randomUUID().toString();
        this.invite = randomInvite();
        this.isPublic = false;
        generateMapSeed();

        this.entities = new ArrayList<>();
        this.entitiesId = 0;
        this.players = new ArrayList<>();
        addPlayer(player);
        this.admUsername = player.getUsername();
    }

    public void addPlayer(Player player) {
        players.add(player);
        entities.add(new Entity(player, ++entitiesId));
    }

    public Player getPlayerByUsername(String username) {
        for (int i = 0; i < players.size(); i++) {
            var player = players.get(i);
            if (player.getUsername().equals(username)) return player;
        }
        return null;
    }

    public Entity getEntityByUsername(String username) {
        for (int i = 0; i < entities.size(); i++) {
            var entity = entities.get(i);
            if (entity.getUsername().equals(username)) return entity;
        }
        return null;
    }

    public void setPlayerReady(String username) {
        var player = getPlayerByUsername(username);
        player.setReady(true);

        var readyPlayers = 0;
        for (int i = 0; i < players.size(); i++) {
            if (players.get(i).isReady()) readyPlayers++;
        }
        if (readyPlayers == players.size()) {
            setStarted(true);
        }
    }

    public String randomInvite() {
        return RandomStringUtils.randomAlphanumeric(4).toUpperCase();
    }

    public Entity getEntityById(int id) {
        for (int i = 0; i < entities.size(); i++) {
            var entity = entities.get(i);
            if (entity.getId() == id) return entity;
        }
        return null;
    }

    public WaitingDTO toWaitingDTO() {
        return new WaitingDTO(this);
    }

    public DungeonDTO toDTO() {
        return new DungeonDTO(this, null);
    }

    public DungeonDTO toDTO(Entity reqEntity) {
        return new DungeonDTO(this, reqEntity);
    }

    public Entity updateEntity(JSONObject data) {
        var entity = getEntityById(data.getInt("entityId"));
        entity.setData(data.getJSONObject("data"));
        return entity;
    }

    public void removePlayer(String username) {
        String removed = "";
        for (int i = 0; i < players.size(); i++) {
            if (players.get(i).getUsername().equals(username)) {
                var player = players.remove(i);
                player.setOnline(false);
                removed = player.getUsername();
                break;
            }
        }
        if (!removed.isEmpty() && admUsername.equals(removed) && players.size() > 0) {
            setAdmUsername( players.get(0).getUsername() );
        }
    }

    public void generateMapSeed() {
        long min = 0L;
        long max = 4294967295L; //max 32 bit unsigned int
        mapSeed = min + (long) (Math.random() * (max - min));
    }

    public TileEntity getTileEntityById(String id) {
        for (int i = 0; i < tileEntities.size(); i++) {
            var tileEntity = tileEntities.get(i);
            if (tileEntity.getId().equals(id)) return tileEntity;
        }
        return null;
    }

    public void addTileEntity(TileEntity tileEntity) {
        tileEntities.add(tileEntity);
    }
}