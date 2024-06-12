package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.Player;

@Repository("playerRepository")
public interface PlayerRepository extends JpaRepository <Player, Integer> {
	public abstract Player findByName(String name);
	
	public abstract Player findById(int id);
}
