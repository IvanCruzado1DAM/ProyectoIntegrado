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
public class Orderr {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int idorder;
	private int numtable;
	private int idreservetable;
	private String drinks;
	private Double total;
	private boolean paid;

}
