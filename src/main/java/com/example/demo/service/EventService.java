package com.example.demo.service;

import java.util.List;
import com.example.demo.entity.Event;
import com.example.demo.model.EventModel;

public interface EventService {

	public abstract List<EventModel> listAllEvents();
	
	public abstract Event addEvent(EventModel eventModel);

	public abstract int removeEvent(int id);

	public abstract Event updateEvent(int id, EventModel eventModel);

	public abstract Event transformEvent(EventModel eventModel);

	public abstract EventModel transformEventModel(Event event);
	
	public abstract Event loadEventById(int id);

	public abstract Event findEventByname(String name);
	
	boolean exists(int id);

	EventModel convertImageToBase64(EventModel event);


}
