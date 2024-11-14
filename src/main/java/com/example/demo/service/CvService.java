package com.example.demo.service;

import java.util.List;
import java.util.Map;

import com.example.demo.entity.Cv;
import com.example.demo.entity.Drink;
import com.example.demo.model.CvModel;
import com.example.demo.model.DrinkModel;

public interface CvService {

	public abstract List<CvModel> listAllCvs();
	
	public abstract Cv transformCv(CvModel cvModel);

	public abstract CvModel transformCvModel(Cv cv);
	
	public abstract Cv loadCvById(int id);
	
	boolean exists(int id);

	//Map<String, List<DrinkModel>> convertImagesToBase64(Map<String, List<DrinkModel>> drinksByCategory);

}
