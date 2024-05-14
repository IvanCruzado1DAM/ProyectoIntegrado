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
	private int id_coach;
	private String stadium;
	private String image_stadium;
	private int id_president;
	private int capital;
	private int occupation;
}
