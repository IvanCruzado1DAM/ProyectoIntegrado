package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Multimedia;
import com.example.demo.model.GameModel;
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
		// TODO Auto-generated method stub
		return null;
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
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public MultimediaModel transformMultimediaModel(Multimedia multimedia) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Multimedia loadMultimediaById(int id) {
		// TODO Auto-generated method stub
		return null;
	}

}
