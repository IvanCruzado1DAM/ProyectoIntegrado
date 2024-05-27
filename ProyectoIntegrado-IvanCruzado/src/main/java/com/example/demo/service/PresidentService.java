package com.example.demo.service;

import java.util.List;

import com.example.demo.entity.President;
import com.example.demo.model.PresidentModel;
import com.example.demo.model.TeamModel;

public interface PresidentService {
	
	public abstract List<PresidentModel> listAllPresidents();
	
	public abstract President addPresident(PresidentModel presidentModel);

	public abstract int removePresident(int id);

	public abstract President updatePresident(PresidentModel presidentModel);

	public abstract President transformPresident(PresidentModel presidentModel);

	public abstract PresidentModel transformPresidentModel(President president);

	public abstract President loadPresidentById(int id);

	public abstract President findByIdteam_president(int id);
	
}
