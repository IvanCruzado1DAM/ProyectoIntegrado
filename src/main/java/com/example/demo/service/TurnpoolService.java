package com.example.demo.service;

import java.util.List;

import com.example.demo.entity.Turnpool;
import com.example.demo.model.TurnpoolModel;

public interface TurnpoolService {
	
	public abstract Turnpool addTurnpool(TurnpoolModel turnpoolModel);
	
	public abstract Turnpool updateTurnpool(int id, TurnpoolModel turnpoolModel);
	
	public abstract Turnpool transformTurnpool(TurnpoolModel turnpoolModel);

	public abstract TurnpoolModel transformTurnpoolModel(Turnpool turnpool);

	public abstract List<TurnpoolModel> listAllTurnpoolbyuser(int iduserpool);
}
