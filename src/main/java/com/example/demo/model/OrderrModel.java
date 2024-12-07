package com.example.demo.model;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class OrderrModel {
	private int idorder;
	private int numtable;
	private int idreservetable;
	private String drinks;
	private Double total;
	private boolean paid;
}
