package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Team;
import com.example.demo.entity.Game;
import com.example.demo.model.GameModel;
import com.example.demo.model.TeamModel;
import com.example.demo.repository.GameRepository;
import com.example.demo.service.GameService;

@Service("gameService")
public class GameServiceImpl implements GameService{
	
	@Autowired
	@Qualifier("gameRepository")
	private GameRepository gameRepository;
	
	
	@Override
	public List<GameModel> listAllGames(int idTeam) {
		ModelMapper modelMapper = new ModelMapper();
        List<Game> gameList = gameRepository.findAll();
        
        // Filtrar los juegos basados en si el idTeam coincide con id_local_team o id_visitant_team
        List<GameModel> filteredGames = gameList.stream()
                .filter(game -> game.getIdLocalTeam() == idTeam || game.getIdVisitantTeam() == idTeam)
                .map(game -> modelMapper.map(game, GameModel.class))
                .collect(Collectors.toList());
        
        return filteredGames;
	}

}
