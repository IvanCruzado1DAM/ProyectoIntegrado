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
public class Opinion {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int idopinion;
	private int iduseropinion;
	private int score;
	private String comment;
}
