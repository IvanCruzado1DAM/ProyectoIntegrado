package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Multimedia;
import com.example.demo.entity.Player;
import com.example.demo.model.MultimediaModel;
import com.example.demo.model.PlayerModel;
import com.example.demo.repository.PlayerRepository;
import com.example.demo.service.PlayerService;

@Service("playerService")
public class PlayerServiceImpl implements PlayerService {
	
	@Autowired
	@Qualifier("playerRepository")
	private PlayerRepository playerRepository;
	
	@Override
	public List<PlayerModel> listAllPlayers() {
		ModelMapper modelMapper = new ModelMapper();
		List<Player> playersList = playerRepository.findAll();
		return playersList.stream().map(p -> modelMapper.map(p, PlayerModel.class))
				.collect(Collectors.toList());
	}

	@Override
	public Player addPlayer(PlayerModel playerModel) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int removePlayer(int id) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public Player updatePlayer(PlayerModel playerModel) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Player transformPlayer(PlayerModel playerModel) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public PlayerModel transformPlayerModel(Player player) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Player loadPlayerById(int id) {
		Player player = playerRepository.findById(id);
		return player;
	}

	@Override
	public List<PlayerModel> listAllPlayersbyIdTeam(int idTeam) {
		ModelMapper modelMapper = new ModelMapper();
		List<Player> playersList = playerRepository.findAll();
		
		List<PlayerModel> filtredplayersList =  playersList.stream()
				 .filter(p -> p.getId_team() == idTeam)
				.map(p -> modelMapper.map(p, PlayerModel.class))
				.collect(Collectors.toList());
		return filtredplayersList;
		
	}

}
