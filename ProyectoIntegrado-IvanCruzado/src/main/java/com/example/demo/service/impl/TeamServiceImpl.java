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
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

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
		teamModel.setName(teamModel.getName());	
		teamModel.setCity(teamModel.getCity());	
		teamModel.setId_president(teamModel.getId_president());	
		teamModel.setStadium(teamModel.getStadium());	
		teamModel.setId_coach(teamModel.getId_coach());	
		teamModel.setCapital(teamModel.getCapital());	
		teamModel.setOccupation(teamModel.getOccupation());	
		Team t = transformTeam(teamModel);
		return teamRepository.save(t);
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
		if (teamModel == null) {
			return null; 
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(teamModel, Team.class);
	}

	@Override
	public TeamModel transformTeamModel(Team team) {
		if (team == null) {
			return null; 
		}
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(team, TeamModel.class);
	}

	@Override
	public TeamModel findById(int idteam_president) {
		Team t = teamRepository.findById(idteam_president);
		TeamModel team=transformTeamModel(t);
		return team;
	}

	@Override
	public void addBadge(Team team, MultipartFile badgeFile, String direfichero) {
		if (!badgeFile.isEmpty()) {
			// Guarda el archivo en el directorio especificado
			Path rutalogo = Paths.get(direfichero + badgeFile.getOriginalFilename());
			try {
				Files.write(rutalogo, badgeFile.getBytes());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			System.out.println(badgeFile.getOriginalFilename());
			team.setBadge("/imgs/escudos/" + badgeFile.getOriginalFilename());
		}
					
		
	}

	@Override
	public boolean exists(TeamModel t) {
		Team team=teamRepository.findByName(t.getName());
		if( team != null) {
			return true;
		}
		return false;
	}

}
