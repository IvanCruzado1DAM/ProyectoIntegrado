package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Coach;
import com.example.demo.entity.Player;
import com.example.demo.entity.President;
import com.example.demo.model.PlayerModel;
import com.example.demo.model.PresidentModel;
import com.example.demo.model.TeamModel;
import com.example.demo.repository.PresidentRepository;
import com.example.demo.service.PresidentService;

@Service("presidentService")
public class PresidentServiceImpl implements PresidentService{

	@Autowired
	@Qualifier("presidentRepository")
	private PresidentRepository presidentRepository;
	
	@Override
	public List<PresidentModel> listAllPresidents() {
		ModelMapper modelMapper = new ModelMapper();
		List<President> presidentsList = presidentRepository.findAll();
		return presidentsList.stream().map(p -> modelMapper.map(p, PresidentModel.class))
				.collect(Collectors.toList());
	}

	@Override
	public President addPresident(PresidentModel presidentModel) {
		presidentModel.setName(presidentModel.getName());
		presidentModel.setNacionality(presidentModel.getNacionality());
		presidentModel.setImage(presidentModel.getImage());
		presidentModel.setArrival_year(presidentModel.getArrival_year());
		presidentModel.setIdteampresident(presidentModel.getIdteampresident());
		President p = transformPresident(presidentModel);
		return presidentRepository.save(p);
	}

	@Override
	public int removePresident(int id) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public President updatePresident(PresidentModel presidentModel) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public President transformPresident(PresidentModel presidentModel) {
		if (presidentModel == null) {
			return null; 
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(presidentModel, President.class);
	}

	@Override
	public PresidentModel transformPresidentModel(President president) {
		if (president == null) {
			return null; 
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(president, PresidentModel.class);
	}

	@Override
	public President loadPresidentById(int id) {
		President presi = presidentRepository.findById(id);
		return presi;
	}

	@Override
	public President findByIdteam_president(int id) {
		 return presidentRepository.findByIdteampresident(id);
	}

}
