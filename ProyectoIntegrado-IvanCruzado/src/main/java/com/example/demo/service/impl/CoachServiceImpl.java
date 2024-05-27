package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Coach;
import com.example.demo.entity.Dietist;
import com.example.demo.entity.Player;
import com.example.demo.model.CoachModel;
import com.example.demo.model.DietistModel;
import com.example.demo.model.PlayerModel;
import com.example.demo.repository.CoachRepository;
import com.example.demo.service.CoachService;

@Service("coachService")
public class CoachServiceImpl implements CoachService {

	@Autowired
	@Qualifier("coachRepository")
	private CoachRepository coachRepository;
	
	@Override
	public List<CoachModel> listAllCoachs() {
		ModelMapper modelMapper = new ModelMapper();
		List<Coach> coachsList = coachRepository.findAll();
		return coachsList.stream().map(p -> modelMapper.map(p, CoachModel.class))
				.collect(Collectors.toList());
	}

	@Override
	public Coach addCoach(CoachModel coachModel) {
		coachModel.setName(coachModel.getName());
		coachModel.setNacionality(coachModel.getNacionality());
		coachModel.setPhoto(coachModel.getPhoto());
		coachModel.setArrival_season(coachModel.getArrival_season());
		coachModel.setIdteam_coach(coachModel.getIdteam_coach());
		Coach c = transformCoach(coachModel);
		return coachRepository.save(c);
	}

	@Override
	public int removeCoach(int id) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public Coach updateCoach(CoachModel coachModel) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Coach transformCoach(CoachModel coachModel) {
		if (coachModel == null) {
			return null; 
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(coachModel, Coach.class);
	}

	@Override
	public CoachModel transformCoachModel(Coach coach) {
		if (coach == null) {
			return null; 
		}
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(coach, CoachModel.class);
	}

	@Override
	public Coach loadCoachById(int id) {
		Coach coach = coachRepository.findById(id);
		return coach;
	}


}
