package com.example.demo.service;

import java.util.List;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.entity.Multimedia;
import com.example.demo.model.CoachModel;
import com.example.demo.model.MultimediaModel;

public interface MultimediaService {
	
	public abstract List<MultimediaModel> listAllMultimedia();
	
	public abstract Multimedia addMultimedia(MultimediaModel multimediaModel);

	public abstract int removeMultimedia(int id);

	public abstract Multimedia updateMultimedia(int id, RedirectAttributes flash, MultipartFile multimediaFile, MultimediaModel model);
	
	public Multimedia updateMultimediaWithoutFile(int id, RedirectAttributes flash, MultimediaModel model);
	
	public abstract Multimedia transformMultimedia(MultimediaModel multimediaModel);

	public abstract MultimediaModel transformMultimediaModel(Multimedia multimedia);

	public abstract Multimedia loadMultimediaById(int id);

	public abstract List<MultimediaModel> listAllMultimediabyIdTeam(int idTeam);

	void addImageMultimedia(Multimedia multimedia, MultipartFile multimediaFile, String direfichero);
}
