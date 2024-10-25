package com.example.demo.service.impl;

import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Drink;
import com.example.demo.model.DrinkModel;
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
	    // Crear una nueva instancia de Drink a partir del modelo
	    Drink newDrink = new Drink();
	    newDrink.setDrinkname(drinkModel.getDrinkname());
	    newDrink.setDrinkcategory(drinkModel.getDrinkcategory());
	    newDrink.setDrinkdescription(drinkModel.getDrinkdescription());
	    newDrink.setDrinkprice(drinkModel.getDrinkprice());

	    // Asegurarse de que la imagen también se asigne
	    if (drinkModel.getDrinkimage() != null) {
	        newDrink.setDrinkimage(drinkModel.getDrinkimage()); // Mantener la imagen como byte[]
	    } else {
	        // Puedes manejar el caso donde la imagen no esté presente
	        // Por ejemplo, puedes lanzar una excepción o establecer una imagen por defecto
	        throw new IllegalArgumentException("Image data is required");
	    }

	    // Guardar en la base de datos
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
			if (drinkModel.getDrinkimage() != null) {
	            drink.setDrinkimage(drinkModel.getDrinkimage()); 
	        }
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
		System.out.println("holaaaaaaaaaaaaaaaaaaa2");
	    DrinkModel drinkModel = new DrinkModel();
	    drinkModel.setIddrink(drink.getIddrink());
	    drinkModel.setDrinkname(drink.getDrinkname());
	    drinkModel.setDrinkcategory(drink.getDrinkcategory());
	    drinkModel.setDrinkdescription(drink.getDrinkdescription());
	    drinkModel.setDrinkprice(drink.getDrinkprice());
	    
	    // Asignar la imagen de Drink a DrinkModel
	    if (drink.getDrinkimage() != null) {
	        drinkModel.setDrinkimage(drink.getDrinkimage());
	    }

	    return drinkModel;
	}
	
	@Override
	public List<DrinkModel> transformListDrinkModel(List<Drink> drinks) {
	    List<DrinkModel> drinkModels = new ArrayList<>();

	    for (Drink drink : drinks) {
	        DrinkModel drinkModel = new DrinkModel();
	        drinkModel.setIddrink(drink.getIddrink());
	        drinkModel.setDrinkname(drink.getDrinkname());
	        drinkModel.setDrinkcategory(drink.getDrinkcategory());
	        drinkModel.setDrinkdescription(drink.getDrinkdescription());
	        drinkModel.setDrinkprice(drink.getDrinkprice());
	        
	        // Assign image if it exists
	        if (drink.getDrinkimage() != null) {
	            drinkModel.setDrinkimage(drink.getDrinkimage());
	        }

	        // Add the mapped model to the result list
	        drinkModels.add(drinkModel);
	    }

	    return drinkModels;
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
	
	@Override
	public Map<String, List<DrinkModel>> listAllDrinksCategorys() {
	    ModelMapper modelMapper = new ModelMapper();

	    return drinkRepository.findAll().stream()
	        .map(drink -> modelMapper.map(drink, DrinkModel.class)) 
	        .collect(Collectors.groupingBy(DrinkModel::getDrinkcategory)); 
	}
	
	@Override
	// En DrinkService
	public Map<String, List<DrinkModel>> convertImagesToBase64(Map<String, List<DrinkModel>> drinksByCategory) {
	    // Recorremos solo las categorías, evitando iterar múltiples veces sobre la misma lista de bebidas
	    for (String category : drinksByCategory.keySet()) {
	        // Obtenemos bebidas solo para la categoría actual
	        List<DrinkModel> drinks = transformListDrinkModel(drinkRepository.findByDrinkcategory(category));
	        
	        // Convertimos a Base64 solo si es necesario
	        drinks.parallelStream().forEach(drink -> {
	            if (drink.getDrinkimage() != null && (drink.getImageUrl() == null || drink.getImageUrl().isEmpty())) {
	                String base64Image = Base64.getEncoder().encodeToString(drink.getDrinkimage());
	                drink.setImageUrl("data:image/jpeg;base64," + base64Image);
	            }
	        });

	        // Actualizamos el mapa con la lista procesada
	        drinksByCategory.put(category, drinks);
	    }
	    return drinksByCategory;
	}




}
