package com.example.demo.service.impl;

import java.util.Base64;
import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Event;
import com.example.demo.model.EventModel;
import com.example.demo.repository.EventRepository;
import com.example.demo.service.EventService;

@Service("eventService")
public class EventServiceImpl implements EventService {

	@Autowired
	@Qualifier("eventRepository")
	private EventRepository eventRepository;

	@Override
	public List<EventModel> listAllEvents() {
		ModelMapper modelMapper = new ModelMapper();
		List<Event> eventsList = eventRepository.findAll();
		return eventsList.stream().map(user -> modelMapper.map(user, EventModel.class)).collect(Collectors.toList());
	}

	@Override
	public Event addEvent(EventModel eventModel) {
		Event newEvent = new Event();
		newEvent.setEventname(eventModel.getEventname());
		newEvent.setEventdescription(eventModel.getEventdescription());
		newEvent.setEventenddate(eventModel.getEventenddate());

		if (eventModel.getEventimage() != null) {
			newEvent.setEventimage(eventModel.getEventimage()); // Mantener la imagen como byte[]
		} else {

			throw new IllegalArgumentException("Image data is required");
		}

		// Guardar en la base de datos
		return eventRepository.save(newEvent);
	}

	@Override
	public int removeEvent(int id) {
	    if (eventRepository.existsById(id)) {  
	        eventRepository.deleteById(id);    
	        return id;                        
	    }
	    return -1; 
	}


	@Override
	public Event updateEvent(int id, EventModel eventModel) {
		Event event = eventRepository.findByIdevent(id);
		if (event != null) {
			event.setEventname(eventModel.getEventname());
			event.setEventdescription(eventModel.getEventdescription());
			event.setEventenddate(eventModel.getEventenddate());
			if (eventModel.getEventimage() != null) {
				event.setEventimage(eventModel.getEventimage());
			}

			return eventRepository.save(event);
		}
		return null;
	}

	@Override
	public Event transformEvent(EventModel eventModel) {
		if (eventModel == null) {
			return null;
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(eventModel, Event.class);
	}

	@Override
	public EventModel transformEventModel(Event event) {
		EventModel eventModel = new EventModel();
		eventModel.setIdevent(event.getIdevent());
		eventModel.setEventname(event.getEventname());
		eventModel.setEventdescription(event.getEventdescription());
		eventModel.setEventenddate(event.getEventenddate());

		// Asignar la imagen de Drink a DrinkModel
		if (event.getEventimage() != null) {
			eventModel.setEventimage(event.getEventimage());
		}

		return eventModel;
	}

	@Override
	public Event loadEventById(int id) {
		Event event = eventRepository.findByIdevent(id);
		return event;
	}

	@Override
	public Event findEventByname(String name) {
		Event event = eventRepository.findByEventname(name);
		return event;
	}

	@Override
	public boolean exists(int id) {
		Event e=eventRepository.findByIdevent(id);
		if( e != null) {
			return true;
		}
		return false;
	}

	@Override
	public EventModel convertImageToBase64(EventModel event) {
	    if (event.getEventimage() != null && (event.getImageUrl() == null || event.getImageUrl().isEmpty())) {
	        // Convierte la imagen a una cadena en Base64
	        String base64Image = Base64.getEncoder().encodeToString(event.getEventimage());
	        event.setImageUrl("data:image/jpeg;base64," + base64Image);
	    }
	    return event;
	}


}
