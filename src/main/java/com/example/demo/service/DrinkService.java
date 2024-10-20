package com.example.demo.service;

import java.util.List;

import com.example.demo.entity.Drink;
import com.example.demo.model.DrinkModel;

public interface DrinkService {

	public abstract List<DrinkModel> listAllDrinks();
	
	public abstract Drink addDrink(DrinkModel drinkModel);

	public abstract int removeDrink(int id);

	public abstract Drink updateDrink(int id, DrinkModel drinkModel);

	public abstract Drink transformDrink(DrinkModel drinkModel);

	public abstract DrinkModel transformDrinkModel(Drink drink);
	
	public abstract Drink loadDrinkById(int id);

	public abstract Drink findDrinkByDrinkname(String drinkname);
	
	boolean exists(int id);

}
