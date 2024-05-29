package com.example.demo.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.example.demo.entity.Multimedia;
import com.example.demo.model.MultimediaModel;

public interface MultimediaService {
	
	public abstract List<MultimediaModel> listAllMultimedia();
	
	public abstract Multimedia addMultimedia(MultimediaModel multimediaModel);

	public abstract int removeMultimedia(int id);

	public abstract Multimedia updateMultimedia(MultimediaModel multimediaModel);

	public abstract Multimedia transformMultimedia(MultimediaModel multimediaModel);

	public abstract MultimediaModel transformMultimediaModel(Multimedia multimedia);

	public abstract Multimedia loadMultimediaById(int id);

	public abstract List<MultimediaModel> listAllMultimediabyIdTeam(int idTeam);

	void addImageMultimedia(Multimedia multimedia, MultipartFile multimediaFile, String direfichero);
}
