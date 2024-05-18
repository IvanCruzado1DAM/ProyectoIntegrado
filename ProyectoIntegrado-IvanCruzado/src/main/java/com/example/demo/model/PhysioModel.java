package com.example.demo.model;

import java.sql.Timestamp;

import jakarta.persistence.Column;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PhysioModel {
	private int id_physio;
	private String name;
	private int age; 	
	private int idteam_physio;
}
