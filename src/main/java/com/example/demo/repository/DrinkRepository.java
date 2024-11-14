package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.Drink;

@Repository("drinkRepository")
public interface DrinkRepository extends JpaRepository <Drink, Integer> {
	public abstract Drink findByDrinkname(String Drinkname);
	
	public abstract List<Drink> findByDrinkcategory(String Drinkcategory);
	
	public abstract Drink findById(int id);
}
