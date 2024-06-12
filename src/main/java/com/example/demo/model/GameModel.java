package com.example.demo.model;

import java.sql.Timestamp;

import jakarta.persistence.Column;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class GameModel {

	private int id_game;
	private int idLocalTeam;
	private int idVisitantTeam;
	private int numberGame;
	private Timestamp date;
	private int tickets;
	private String score;
}
