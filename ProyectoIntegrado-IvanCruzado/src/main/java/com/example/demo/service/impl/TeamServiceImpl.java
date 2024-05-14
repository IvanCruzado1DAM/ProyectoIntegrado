package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Team;
import com.example.demo.entity.User;
import com.example.demo.model.TeamModel;
import com.example.demo.model.UserModel;
import com.example.demo.repository.TeamRepository;
import com.example.demo.service.TeamService;

@Service("teamService")
public class TeamServiceImpl implements TeamService {
	@Autowired
	@Qualifier("teamRepository")
	private TeamRepository teamRepository;
	
	@Override
	public List<TeamModel> listAllTeams() {
		ModelMapper modelMapper = new ModelMapper();
		List<Team> teamList = teamRepository.findAll();
		return teamList.stream().map(team -> modelMapper.map(team, TeamModel.class))
				.collect(Collectors.toList());
	}
	
	@Override
	public Team loadTeamById(int id) {
		Team team = teamRepository.findById(id);
		return team;
	}
	

	@Override
	public Team addTeam(TeamModel teamModel) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int removeTeam(int id) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public Team updateTeam(TeamModel teamModel) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Team transformTeam(TeamModel teamModel) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public TeamModel transformTeamModel(Team team) {
		// TODO Auto-generated method stub
		return null;
	}

}
