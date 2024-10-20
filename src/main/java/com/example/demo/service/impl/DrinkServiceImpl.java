package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;


import com.example.demo.entity.Drink;
import com.example.demo.entity.User;
import com.example.demo.model.DrinkModel;
import com.example.demo.model.UserModel;
import com.example.demo.repository.DrinkRepository;
import com.example.demo.service.DrinkService;

@Service("drinkService")
public class DrinkServiceImpl implements DrinkService{
	
	@Autowired
	@Qualifier("drinkRepository")
	private DrinkRepository drinkRepository;
	
	@Override
	public List<DrinkModel> listAllDrinks() {
		ModelMapper modelMapper = new ModelMapper();
		List<Drink> drinksList = drinkRepository.findAll();
		return drinksList.stream().map(user -> modelMapper.map(user, DrinkModel.class))
				.collect(Collectors.toList());
	}

	@Override
	public Drink addDrink(DrinkModel drinkModel) {
		Drink newDrink = new Drink();
		newDrink.setDrinkname(drinkModel.getDrinkname());
		newDrink.setDrinkcategory(drinkModel.getDrinkcategory());
		newDrink.setDrinkdescription(drinkModel.getDrinkdescription());
		newDrink.setDrinkimage(drinkModel.getDrinkimage());
		newDrink.setDrinkprice(drinkModel.getDrinkprice());
		
		return drinkRepository.save(newDrink);
	}

	@Override
	public int removeDrink(int id) {
		drinkRepository.deleteById(id);
		return id;
	}

	@Override
	public Drink updateDrink(int id, DrinkModel drinkModel) {
		Drink drink = drinkRepository.findById(id);
		if (drink != null) {
			drink.setDrinkname(drinkModel.getDrinkname());
			drink.setDrinkcategory(drinkModel.getDrinkcategory());
			drink.setDrinkdescription(drinkModel.getDrinkdescription());
			drink.setDrinkimage(drinkModel.getDrinkimage());
			drink.setDrinkprice(drinkModel.getDrinkprice());

			return drinkRepository.save(drink);
		}
		return null;
	}

	@Override
	public Drink transformDrink(DrinkModel drinkModel) {
		if (drinkModel == null) {
			return null; 
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(drinkModel, Drink.class);
	}

	@Override
	public DrinkModel transformDrinkModel(Drink drink) {
		if (drink == null) {
			return null; 
		}
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(drink, DrinkModel.class);
	}

	@Override
	public Drink loadDrinkById(int id) {
		Drink drink = drinkRepository.findById(id);
		return drink;
	}

	@Override
	public Drink findDrinkByDrinkname(String drinkname) {
		Drink drink = drinkRepository.findByDrinkname(drinkname);
		return drink;
	}
	
	@Override
	public boolean exists(int id) {
		Drink d=drinkRepository.findById(id);
		if( d != null) {
			return true;
		}
		return false;
	}

}
