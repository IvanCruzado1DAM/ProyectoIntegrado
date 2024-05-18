package com.example.demo.entity;

import java.sql.Timestamp;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
public class President {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id_president;
	private String name;
	private String nacionality;
	private String image;
	private int arrival_year;
	private int  idteam_president;

}
