package com.patodesapatos.dungeons.domain;

import org.json.JSONObject;

import com.patodesapatos.dungeons.controller.MessageType;

public abstract class WebSocketDTO {
    protected JSONObject packet = new JSONObject();

    public WebSocketDTO(MessageType type) {
        this(type, new JSONObject());
    }

    public WebSocketDTO(MessageType type, JSONObject data) {
        packet.put("messageType", type);
        packet.put("data", data);
    }

    @Override
    public String toString() {
        return packet.toString();
    }

    public JSONObject getData() {
        return packet.getJSONObject("data");
    }
}