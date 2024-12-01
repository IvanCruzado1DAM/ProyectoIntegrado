package com.example.demo.service;

import java.util.List;

import com.example.demo.entity.Drink;
import com.example.demo.entity.Opinion;
import com.example.demo.model.CvModel;
import com.example.demo.model.DrinkModel;
import com.example.demo.model.OpinionModel;

public interface OpinionService {

	public abstract List<OpinionModel> listAllOpinions();
	
	public abstract Opinion addOpinion(OpinionModel opinionModel);
	
	public abstract Opinion updateOpinion(int id, OpinionModel opinionModel);
	
	public abstract Opinion transformOpinion(OpinionModel opinionModel);

	public abstract OpinionModel transformOpinionModel(Opinion opinion);
	
	public abstract Opinion loadOpinionById(int id);
	
	boolean exists(int id);

	public abstract Opinion loadOpinionByIduser(int id);
	
}
