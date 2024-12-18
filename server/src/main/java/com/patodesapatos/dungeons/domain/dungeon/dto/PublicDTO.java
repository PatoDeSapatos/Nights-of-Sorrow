package com.patodesapatos.dungeons.domain.dungeon.dto;

import com.patodesapatos.dungeons.domain.dungeon.Dungeon;

public class PublicDTO {
    public final String adm;
    public final String invite;

    public PublicDTO(Dungeon dungeon) {
        adm = dungeon.getAdmUsername();
        invite = dungeon.getInvite();
    }
}