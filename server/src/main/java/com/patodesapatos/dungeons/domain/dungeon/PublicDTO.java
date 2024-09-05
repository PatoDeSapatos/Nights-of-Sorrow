package com.patodesapatos.dungeons.domain.dungeon;

public class PublicDTO {
    public final String adm;
    public final String invite;

    public PublicDTO(Dungeon dungeon) {
        adm = dungeon.getAdmUsername();
        invite = dungeon.getInvite();
    }
}