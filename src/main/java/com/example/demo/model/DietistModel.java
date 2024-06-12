package com.example.demo.model;

import java.sql.Timestamp;

import jakarta.persistence.Column;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DietistModel {

	private int id_dietist;
	private String name;
	private int age; 	
	private int idteam_dietist;
}
