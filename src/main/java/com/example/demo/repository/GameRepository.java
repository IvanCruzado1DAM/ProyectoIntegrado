package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.Game;
import com.example.demo.entity.Team;

@Repository("gameRepository")
public interface GameRepository extends JpaRepository <Game, Integer> {
	public abstract Game findById(int id);
}
