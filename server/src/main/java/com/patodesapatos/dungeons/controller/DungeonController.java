package com.patodesapatos.dungeons.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
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
    public ResponseEntity<ArrayList<PublicDTO>> getAllPublic() {
        return ResponseEntity.ok(dungeonService.getAllPublic());
    }

    @GetMapping("public?limit={limit}&offset={offset}")
    public ResponseEntity<PublicOffsetDTO> getPublicOffset(@PathVariable int limit, @PathVariable int offset) {
        ArrayList<PublicDTO> dungeons = dungeonService.getAllPublic();

        if (offset + limit >= dungeons.size()) {
            limit = dungeons.size()-1;
        } 

        PublicOffsetDTO dto = new PublicOffsetDTO(dungeons.subList(offset, offset + limit), dungeons.size());

        return ResponseEntity.ok(dto);
    }

}