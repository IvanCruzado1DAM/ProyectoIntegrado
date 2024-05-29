package com.example.demo.service.impl;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.entity.Multimedia;
import com.example.demo.model.MultimediaModel;
import com.example.demo.repository.MultimediaRepository;
import com.example.demo.service.MultimediaService;

@Service("multiService")
public class MultimediaServiceImpl implements MultimediaService {
	@Autowired
	@Qualifier("multiRepository")
	private MultimediaRepository multiRepository;
	
	@Override
	public List<MultimediaModel> listAllMultimedia() {
		ModelMapper modelMapper = new ModelMapper();
		List<Multimedia> multiList = multiRepository.findAll();
		return multiList.stream().map(multi -> modelMapper.map(multi, MultimediaModel.class))
				.collect(Collectors.toList());
	}
	
	@Override
	public List<MultimediaModel> listAllMultimediabyIdTeam(int idTeam) {
		ModelMapper modelMapper = new ModelMapper();
		List<Multimedia> multiList = multiRepository.findAll();
		
		List<MultimediaModel> filtredmultiList =  multiList.stream()
				 .filter(multi -> multi.getIdteammultimedia() == idTeam)
				.map(multi -> modelMapper.map(multi, MultimediaModel.class))
				.collect(Collectors.toList());
		return filtredmultiList;
	}

	@Override
	public Multimedia addMultimedia(MultimediaModel multimediaModel) {
		multimediaModel.setTitle_new(multimediaModel.getTitle_new());
		multimediaModel.setDescription_new(multimediaModel.getDescription_new());
		multimediaModel.setImage(multimediaModel.getImage());
		multimediaModel.setTitle_video(multimediaModel.getTitle_video());
		multimediaModel.setVideo(multimediaModel.getVideo());
		multimediaModel.setId_multimedia(multimediaModel.getId_multimedia());
		Multimedia m = transformMultimedia(multimediaModel);
		return multiRepository.save(m);
	}

	@Override
	public int removeMultimedia(int id) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public Multimedia updateMultimedia(MultimediaModel multimediaModel) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Multimedia transformMultimedia(MultimediaModel multimediaModel) {
		if (multimediaModel == null) {
			return null; 
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(multimediaModel, Multimedia.class);
	}

	@Override
	public MultimediaModel transformMultimediaModel(Multimedia multimedia) {
		if (multimedia == null) {
			return null; 
		}
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(multimedia, MultimediaModel.class);
	}

	@Override
	public Multimedia loadMultimediaById(int id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void addImageMultimedia(Multimedia multimedia, MultipartFile multimediaFile, String direfichero) {
		if (multimediaFile != null && !multimediaFile.isEmpty()) {
			// Guarda el archivo en el directorio especificado
			Path rutalogo = Paths.get(direfichero + multimediaFile.getOriginalFilename());
			try {
				Files.write(rutalogo, multimediaFile.getBytes());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			multimedia.setImage("/imgs/news/" + multimediaFile.getOriginalFilename());
		}
		
	}

}
