package com.example.demo.model;

import jakarta.persistence.Column;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PlayerModel {
	
	private int id_player;
	private String name;
	private String position;
	private int age;
	private String image;
	private int id_team;
	private int dorsal;
	private String nationality;
	private int market_value;
	private int salary;
	private int goals;
	private int assists;
	private int yc;
	private int rc;
	private int contract;
	private String footballaspects;
	private String diet;
	private String transfer_status;
	private boolean is_injured;
	private boolean is_sancionated;	
}
