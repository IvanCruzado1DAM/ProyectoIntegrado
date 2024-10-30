package com.example.demo.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.Event;

@Repository("eventRepository")
public interface EventRepository extends JpaRepository <Event, Integer> {
	public abstract Event findByEventname(String name);
	public abstract Event findByIdevent(int id);
	public abstract List<Event> findByEventenddateBefore(LocalDateTime currentDate);
	public abstract List<Event> findByEventenddateAfter(LocalDateTime currentDate);
}
