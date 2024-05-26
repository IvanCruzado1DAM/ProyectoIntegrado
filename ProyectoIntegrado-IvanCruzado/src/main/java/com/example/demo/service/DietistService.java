package com.example.demo.service;

import java.util.List;

import com.example.demo.entity.Dietist;
import com.example.demo.model.DietistModel;

public interface DietistService {
	
	public abstract List<DietistModel> listAllDietist();
	
	public abstract Dietist addDietist(DietistModel dietistModel);

	public abstract int removeDietist(int id);

	public abstract Dietist updateDietist(DietistModel dietistModel);

	public abstract Dietist transformDietist(DietistModel dietistModel);

	public abstract DietistModel transformDietistModel(Dietist dietist);

	public abstract Dietist loadDietistById(int id);
	
	public abstract List<DietistModel> listAllDietistsbyIdTeam(int idTeam);
	
}
