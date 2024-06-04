package com.example.demo.model;

import jakarta.persistence.Column;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class CoachModel {
	
	private int idCoach;
	private String name;
	private String nacionality;
	private String photo;
	private String arrival_season;
	private int idteamcoach; 
}
