package com.example.demo.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.entity.President;
import com.example.demo.model.CoachModel;
import com.example.demo.model.PresidentModel;
import com.example.demo.model.TeamModel;

public interface PresidentService {
	
	public abstract List<PresidentModel> listAllPresidents();
	
	public abstract President addPresident(PresidentModel presidentModel);

	public abstract int removePresident(int id);

	public abstract President updatePresident(int id, PresidentModel presidentModel,MultipartFile multimediaFile, RedirectAttributes flash);

	public abstract President transformPresident(PresidentModel presidentModel);

	public abstract PresidentModel transformPresidentModel(President president);

	public abstract President loadPresidentById(int id);

	public abstract President findByIdteam_president(int id);
	
}
