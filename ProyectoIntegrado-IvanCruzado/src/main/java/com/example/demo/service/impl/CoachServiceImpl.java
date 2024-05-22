package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Coach;
import com.example.demo.entity.Player;
import com.example.demo.model.CoachModel;
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
		// TODO Auto-generated method stub
		return null;
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
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public CoachModel transformCoachModel(Coach coach) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Coach loadCoachById(int id) {
		Coach coach = coachRepository.findById(id);
		return coach;
	}


}
