package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.Coach;

@Repository("coachRepository")
public interface CoachRepository extends JpaRepository <Coach, Integer> {
	public abstract Coach findByName(String name);
	
	public abstract Coach findById(int id);
}
