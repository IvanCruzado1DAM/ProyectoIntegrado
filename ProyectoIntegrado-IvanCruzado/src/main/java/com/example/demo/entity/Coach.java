package com.example.demo.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
public class Coach {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id_coach;
	private String name;
	private String nacionality;
	private String photo;
	private String arrival_season;
	private int  idteam_coach; 
}
