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
public class Drink {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int iddrink;
	private String drinkname, drinkcategory, drinkdescription;
	private double drinkprice;
	private byte[] drinkimage;
}
