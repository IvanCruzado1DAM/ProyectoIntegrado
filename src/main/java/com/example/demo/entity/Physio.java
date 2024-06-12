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
public class Physio {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id_physio;
	private String name;
	private int age; 	
	private int idteam_physio;
} 
