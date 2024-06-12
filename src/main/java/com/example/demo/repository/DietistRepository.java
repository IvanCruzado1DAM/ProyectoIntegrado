package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.Dietist;

@Repository("dietistRepository")
public interface DietistRepository extends JpaRepository <Dietist, Integer> {
	public abstract Dietist findByName(String name);
	
	public abstract Dietist findById(int id);
}
