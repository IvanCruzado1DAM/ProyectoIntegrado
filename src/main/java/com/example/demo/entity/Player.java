package com.example.demo.entity;

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
public class Player {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id_player;
	@Column
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
