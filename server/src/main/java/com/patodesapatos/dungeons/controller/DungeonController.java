package com.patodesapatos.dungeons.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.patodesapatos.dungeons.domain.dungeon.Dungeon;
import com.patodesapatos.dungeons.domain.dungeon.DungeonService;
import com.patodesapatos.dungeons.domain.dungeon.PublicDTO;

@RestController
@RequestMapping("dungeon")
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
}