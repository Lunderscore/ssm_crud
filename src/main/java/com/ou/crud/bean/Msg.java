package com.ou.crud.bean;

import java.util.HashMap;
import java.util.Map;

public class Msg {
	private int code;
	
	private String message;
	
	private Map<String, Object> content = new HashMap<String, Object>();
	
	public static Msg success(){
		Msg msg = new Msg();
		msg.setCode(100);
		msg.setMessage("操作成功");
		
		return msg;
	}
	
	public static Msg failure(){
		Msg msg = new Msg();
		msg.setCode(200);
		msg.setMessage("操作失败");
		
		return msg;
	}
	
	public Msg add(String key, Object value){
		this.getContent().put(key, value);
		return this;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public Map<String, Object> getContent() {
		return content;
	}

	public void setContent(Map<String, Object> content) {
		this.content = content;
	}
	
}
