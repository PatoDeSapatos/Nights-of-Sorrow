package com.patodesapatos.dungeons.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.patodesapatos.dungeons.domain.dungeon.Dungeon;
import com.patodesapatos.dungeons.domain.dungeon.DungeonService;
import com.patodesapatos.dungeons.domain.dungeon.PublicDTO;
import com.patodesapatos.dungeons.domain.dungeon.PublicOffsetDTO;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("dungeon")
@Slf4j
public class DungeonController {
    @Autowired
    private DungeonService dungeonService;

    @GetMapping
    public ResponseEntity<ArrayList<Dungeon>> getAll() {
        return ResponseEntity.ok(dungeonService.getAll());
    }

    @GetMapping("public")
    public ResponseEntity<PublicOffsetDTO> getPublicOffset(@RequestParam int limit, @RequestParam int offset) {
        ArrayList<PublicDTO> dungeons = dungeonService.getAllPublic();

        if (offset + limit >= dungeons.size()) {
            limit = dungeons.size() - offset;
        }

        PublicOffsetDTO dto = new PublicOffsetDTO(dungeons.subList(offset, offset + limit), dungeons.size());

        return ResponseEntity.ok(dto);
    }
}