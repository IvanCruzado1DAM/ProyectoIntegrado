package com.example.demo.service;

import java.util.List;

import com.example.demo.entity.Physio;
import com.example.demo.model.PhysioModel;
import com.example.demo.model.PlayerModel;

public interface PhysioService {
	
	public abstract List<PhysioModel> listAllPhysios();
	
	public abstract Physio addPhysio(PhysioModel physioModel);

	public abstract int removePhysio(int id);

	public abstract Physio updatePhysio(PhysioModel physioModel);

	public abstract Physio transformPhysio(PhysioModel physioModel);

	public abstract PhysioModel transformPhysioModel(Physio president);

	public abstract Physio loadPhysioById(int id);
	
	public abstract List<PhysioModel> listAllPhysiosbyIdTeam(int idTeam);
	
}
