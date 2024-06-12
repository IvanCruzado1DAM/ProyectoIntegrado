package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.President;
import com.example.demo.model.TeamModel;

@Repository("presidentRepository")
public interface PresidentRepository extends JpaRepository <President, Integer> {
	public abstract President findByName(String name);
	
	public abstract President findById(int id);

	public abstract President findByIdteampresident(int idteampresident);
}
