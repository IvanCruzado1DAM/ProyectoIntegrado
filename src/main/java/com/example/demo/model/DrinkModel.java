package com.example.demo.model;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DrinkModel {
	private int iddrink;
	private String drinkname, drinkcategory, drinkdescription;
	private double drinkprice;
	private byte[] drinkimage;
}
