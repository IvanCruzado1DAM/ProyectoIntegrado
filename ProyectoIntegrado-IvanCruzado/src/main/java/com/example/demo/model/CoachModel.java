package com.example.demo.model;

import jakarta.persistence.Column;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class CoachModel {
	
	private int id_coach;
	private String name;
	private String nacionality;
	private String photo;
	private String arrival_season;
	private int  idteam_coach; 
}
