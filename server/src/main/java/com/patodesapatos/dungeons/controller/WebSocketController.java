package com.patodesapatos.dungeons.controller;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.patodesapatos.dungeons.domain.dungeon.DungeonService;
import com.patodesapatos.dungeons.domain.user.UserService;
import com.patodesapatos.dungeons.domain.WebSocketDTO;
import com.patodesapatos.dungeons.domain.auth.TokenService;
import com.patodesapatos.dungeons.domain.chat.ChatMessage;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class WebSocketController extends TextWebSocketHandler {
    @Autowired
    private TokenService tokenService;
    @Autowired
    private DungeonService dungeonService;
    @Autowired
    private UserService userService;
    private Map<String, WebSocketSession> activeSessions = new HashMap<>();

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String jsonString = message.getPayload();
        JSONObject packet = new JSONObject(jsonString);
        
        MessageType type = MessageType.valueOf(packet.getString("messageType"));
        String token = packet.getString("token");
        JSONObject data = packet.getJSONObject("data");

        var username = tokenService.validateToken(token);
        if (username.isEmpty()) return;

        WebSocketDTO dto;
        switch (type) {
            case PING:
                session.sendMessage(new TextMessage("Pong!"));
                break;
            /**
             * return: WaitingDTO
             */
            case CREATE_DUNGEON:
                dto = dungeonService.createDungeon(username, session);
                sendDTO(dto, session);
                break;
            /**
             * data: {
             *      invite,
             * }
             * return: WaitingDTO to everyone if the dungeon isn't started | DungeonDTO to everyone if dungeon is started UNLESS the joining player
             */
            case JOIN_DUNGEON:
                var dungeon = dungeonService.joinDungeon(data.getString("invite"), username, session);
                if (!dungeon.isStarted()) {
                    sendDTOtoAllPlayers(dungeon.toWaitingDTO(), data);
                } else {
                    sendDTO(dungeon.toWaitingDTO(), session);
                    sendDTOtoAllPlayers(dungeon.toDTO(), data, session.getId());
                }
                break;
            /**
             * data: {
             *      invite
             * }
             * return: DungeonDTO
             */
            case DUNGEON_STATE:
                dungeon = dungeonService.getDungeonByInvite(data.getString("invite"));
                var entity = dungeon.getEntityByUsername(username);

                dto = dungeon.toDTO(entity);
                sendDTO(dto, session);
                break;
            /**
             * data: {
             *      invite,
             *      entityId,
             *      data: {
             *          ...EntityData
             *      }
             * }
             * return: DungeonDTO
             */
            case UPDATE_ENTITY:
                dto = dungeonService.updateEntity(data);
                sendDTO(dto, session);
                break;
            /**
             * data: {
             *      invite,
             *      type,
             *      content
             * }
             * return: ChatMessage
             */
            case SEND_CHAT_MESSAGE:
                data.put("sender", username);
                sendChat(data);
                break;
            /**
             * data: {
             *      invite
             * }
             */
            case SET_PLAYER_READY:
                dto = dungeonService.setPlayerReady(data.getString("invite"), username);
                sendDTOtoAllPlayers(dto, data);
                break;
            /**
             * data: {
             *      invite,
             *      entityId,
             *      level
             * }
             */
            case CHANGE_LEVEL:
                dungeon = dungeonService.getDungeonByInvite(data.getString("invite"));

                entity = dungeon.getEntityById(data.getInt("entityId"));
                entity.setLevel(data.getInt("level"));

                dto = dungeon.toDTO(entity);
                sendDTO(dto, session);
                break;
            case GET_WAITING_STATE:
                dto = dungeonService.getDungeonByInvite(data.getString("invite")).toWaitingDTO();
                sendDTO(dto, session);
                break;
            case CHANGE_DUNGEON_PRIVACY:
                dto = dungeonService.changeDungeonPrivacy(data.getString("invite"), username);
                sendDTOtoAllPlayers(dto, data);
                break;
            case LEAVE_DUNGEON:
                dto = dungeonService.leaveDungeon(data.getString("invite"), username);
                if (dto != null) sendDTOtoAllPlayers(dto, data);
                break;
            default:
                throw new Exception("Message Type: '" + type + "' not accepted!");
        }
    }

    public void sendDTO(WebSocketDTO dto, WebSocketSession session) throws Exception {
        if (dto == null) return;
        session.sendMessage(new TextMessage(dto.toString()));
    }

    public void sendDTOtoAllPlayers(WebSocketDTO dto, JSONObject data, String excludedSessionId) throws Exception {
        if (dto == null) return;
        var dungeon = dungeonService.getDungeonByInvite(data.getString("invite"));
        if (dungeon == null) return;

        for (int i = 0; i < dungeon.getPlayers().size(); i++) {
            String sessionId = userService.getUserById(dungeon.getPlayers().get(i).getUserId()).getSessionId();
            if (sessionId.isEmpty() || sessionId.equals(excludedSessionId)) continue;

            sendDTO(dto, activeSessions.get(sessionId));
        }
    }

    public void sendDTOtoAllPlayers(WebSocketDTO dto, JSONObject data) throws Exception {
        sendDTOtoAllPlayers(dto, data, null);
    }

    public void sendChat(JSONObject data) throws Exception {
        ChatMessage message = new ChatMessage(data);
        sendDTOtoAllPlayers(message, data);
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        activeSessions.put(session.getId(), session);
        log.info("User Connected: {}", session.getId());
        super.afterConnectionEstablished(session);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        String sessionId = session.getId();
        log.info("User Disconnected: {}", sessionId);
        activeSessions.remove(sessionId);
        dungeonService.leaveDungeon(session);
        super.afterConnectionClosed(session, status);
    }
}