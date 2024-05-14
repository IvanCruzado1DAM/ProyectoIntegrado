package com.example.demo.entity;

import java.sql.Timestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
public class Game {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id_game;
	private int idLocalTeam;
	private int idVisitantTeam;
	private int numberGame;
	private Timestamp date;
	private int tickets;
	private String score;
	
}
