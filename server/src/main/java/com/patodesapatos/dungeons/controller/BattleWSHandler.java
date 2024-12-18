package com.patodesapatos.dungeons.controller;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.socket.WebSocketSession;

import com.patodesapatos.dungeons.domain.WebSocketDTO;
import com.patodesapatos.dungeons.domain.dungeon.DungeonService;

public class BattleWSHandler {
    @Autowired
    private static DungeonService dungeonService;
    
    public static void handle(WebSocketController wsc, WebSocketSession session, String username, MessageType type, JSONObject data) throws Exception {
        WebSocketDTO dto;

        switch (type) {
            default:
                throw new Exception("Message Type: '" + type + "' not accepted! (Battle Handler)");
        }
    }
}