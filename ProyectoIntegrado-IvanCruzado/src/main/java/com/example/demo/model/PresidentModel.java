package com.example.demo.model;

import java.sql.Timestamp;

import jakarta.persistence.Column;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PresidentModel {

	private int id_president;
	private String name;
	private String nacionality;
	private String image;
	private int arrival_year;
	private int  idteampresident;
}
