package com.example.demo.model;

import jakarta.persistence.Column;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class TeamModel {

	private int id_team;
	private String name;
	private String city;
	private String badge;	
	private String stadium;
	private int capital;
	private int occupation;
}
