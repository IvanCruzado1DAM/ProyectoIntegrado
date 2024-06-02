package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Team;
import com.example.demo.entity.Game;
import com.example.demo.entity.Physio;
import com.example.demo.model.GameModel;
import com.example.demo.model.PresidentModel;
import com.example.demo.model.TeamModel;
import com.example.demo.repository.GameRepository;
import com.example.demo.service.GameService;

@Service("gameService")
public class GameServiceImpl implements GameService{
	
	@Autowired
	@Qualifier("gameRepository")
	private GameRepository gameRepository;
	
	
	@Override
	public List<GameModel> listAllGames() {
		ModelMapper modelMapper = new ModelMapper();
        List<Game> gameList = gameRepository.findAll();
        
        // Filtrar los juegos basados en si el idTeam coincide con id_local_team o id_visitant_team
        List<GameModel> filteredGames = gameList.stream()
                .map(game -> modelMapper.map(game, GameModel.class))
                .collect(Collectors.toList());
        
        return filteredGames;
	}
	@Override
	public List<GameModel> listAllGamesByTeam(int idTeam) {
		ModelMapper modelMapper = new ModelMapper();
        List<Game> gameList = gameRepository.findAll();
        
        // Filtrar los juegos basados en si el idTeam coincide con id_local_team o id_visitant_team
        List<GameModel> filteredGames = gameList.stream()
                .filter(game -> game.getIdLocalTeam() == idTeam || game.getIdVisitantTeam() == idTeam)
                .map(game -> modelMapper.map(game, GameModel.class))
                .collect(Collectors.toList());
        
        return filteredGames;
	}


	@Override
	public Game addGame(GameModel gameModel) {
		gameModel.setIdLocalTeam(gameModel.getIdLocalTeam());
		gameModel.setIdVisitantTeam(gameModel.getIdVisitantTeam());
		gameModel.setNumberGame(gameModel.getNumberGame());
		gameModel.setDate(gameModel.getDate());
		gameModel.setTickets(gameModel.getTickets());
		gameModel.setScore(gameModel.getScore());
		Game g = transformGame(gameModel);
		return gameRepository.save(g);
	}


	@Override
	public int removeGame(int id) {
		gameRepository.deleteById(id);
		return id;
	}


	@Override
	public Game updateGame(GameModel gameModel) {
		// TODO Auto-generated method stub
		return null;
	}


	@Override
	public Game transformGame(GameModel gameModel) {
		if (gameModel == null) {
			return null; 
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(gameModel, Game.class);
	}


	@Override
	public GameModel transformGameModel(Game game) {
		if (game == null) {
			return null; 
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(game, GameModel.class);
	}


	@Override
	public boolean Verificarequipos(Game game) {
		if(game.getIdLocalTeam() != game.getIdVisitantTeam()) {
			return true;
		}else
			return false;
	}
	
	public boolean exists(int id) {
		Game g=gameRepository.findById(id);
		if( g != null) {
			return true;
		}
		return false;
	}

}
