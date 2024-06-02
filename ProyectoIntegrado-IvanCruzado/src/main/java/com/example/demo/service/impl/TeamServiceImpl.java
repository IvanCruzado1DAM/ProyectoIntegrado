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

import com.example.demo.entity.Coach;
import com.example.demo.entity.President;
import com.example.demo.entity.Team;
import com.example.demo.model.GameModel;
import com.example.demo.model.PlayerModel;
import com.example.demo.model.TeamModel;
import com.example.demo.repository.CoachRepository;
import com.example.demo.repository.PlayerRepository;
import com.example.demo.repository.PresidentRepository;
import com.example.demo.repository.TeamRepository;
import com.example.demo.service.TeamService;

@Service("teamService")
public class TeamServiceImpl implements TeamService {
	@Autowired
	@Qualifier("teamRepository")
	private TeamRepository teamRepository;
	
	@Autowired
	@Qualifier("playerRepository")
	private PlayerRepository playerRepository;
	
	@Autowired
	@Qualifier("coachRepository")
	private CoachRepository coachRepository;
	
	@Autowired
	@Qualifier("presidentRepository")
	private PresidentRepository presidentRepository;
	
	@Autowired
	@Qualifier("playerService")
	private PlayerServiceImpl playerService;
	
	@Autowired
	@Qualifier("gameService")
	private GameServiceImpl gameService;
	
	@Autowired
	@Qualifier("coachService")
	private CoachServiceImpl coachService;
	
	@Autowired
	@Qualifier("presidentService")
	private PresidentServiceImpl presidentService;
	
	
	
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
		// Crear un nuevo equipo usando el modelo proporcionado
	    Team team = transformTeam(teamModel);
	    
	    // Guardar el equipo en la base de datos para obtener el ID
	    Team savedTeam = teamRepository.save(team);
	    
	    // Obtener el ID del equipo recién creado
	    int teamId = savedTeam.getId_team();

	    // Cargar y actualizar el coach con el ID del equipo
	    Coach coach = coachService.loadCoachById(teamModel.getId_coach());
	    coach.setIdteamcoach(teamId);
	    coachRepository.save(coach);

	    // Cargar y actualizar el presidente con el ID del equipo
	    President president = presidentService.loadPresidentById(teamModel.getId_president());
	    president.setIdteampresident(teamId);
	    presidentRepository.save(president);
	    
	    // Devolver el equipo guardado
	    return savedTeam;
	}

	@Override
	public int removeTeam(int id) {
		List<PlayerModel> playersTeam = playerService.listAllPlayersbyIdTeam(id);
		for(PlayerModel p: playersTeam) {			
			p.setId_team(teamRepository.findByName("Agentes Libres").getId_team());
			playerRepository.save(playerService.transformPlayer(p));
		}
		List<GameModel> games=gameService.listAllGamesByTeam(id);
		for(GameModel g: games) {			
			gameService.removeGame(g.getId_game());
		}
		
		System.out.println(id);
		Coach c =coachService.findByIdteam_coach(id);
		System.out.println(c);
		c.setIdteamcoach(teamRepository.findByName("Agentes Libres").getId_team());
		coachRepository.save(c);
		
		President p =presidentService.findByIdteam_president(id);
		p.setIdteampresident(teamRepository.findByName("Agentes Libres").getId_team());
		presidentRepository.save(p);
		teamRepository.deleteById(id);
		return id;
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
