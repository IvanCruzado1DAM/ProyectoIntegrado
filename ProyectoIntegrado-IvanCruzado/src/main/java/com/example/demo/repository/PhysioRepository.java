package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.Physio;

@Repository("physioRepository")
public interface PhysioRepository extends JpaRepository <Physio, Integer> {
	public abstract Physio findByName(String name);
	
	public abstract Physio findById(int id);
}
