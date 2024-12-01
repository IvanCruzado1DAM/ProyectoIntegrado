package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.Opinion;

@Repository("opinionRepository")
public interface OpinionRepository extends JpaRepository <Opinion, Integer> {
	public abstract Opinion findByIdopinion(int id);
	public abstract Opinion findByIduseropinion(int id);
	
}
