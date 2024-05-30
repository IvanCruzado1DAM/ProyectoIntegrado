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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.entity.Player;
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
		playerModel.setName(playerModel.getName());
		playerModel.setPosition(playerModel.getPosition());
		playerModel.setAge(playerModel.getAge());
		playerModel.setImage(playerModel.getImage());
		playerModel.setId_team(playerModel.getId_team());
		playerModel.setDorsal(playerModel.getDorsal());
		playerModel.setNationality(playerModel.getNationality());
		playerModel.setMarket_value(playerModel.getMarket_value());
		playerModel.setSalary(playerModel.getSalary());
		playerModel.setGoals(playerModel.getGoals());
		playerModel.setAssists(playerModel.getAssists());
		playerModel.setYc(playerModel.getYc());
		playerModel.setRc(playerModel.getRc());
		playerModel.setContract(playerModel.getContract());
		playerModel.setFootballaspects(playerModel.getFootballaspects());
		playerModel.setDiet(playerModel.getDiet());
		playerModel.setTransfer_status(playerModel.getTransfer_status());
		playerModel.set_injured(playerModel.is_injured());
		playerModel.set_sancionated(playerModel.is_sancionated());
		Player player=transformPlayer(playerModel);
		return playerRepository.save(player);
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
		if (playerModel == null) {
			return null; 
		}
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(playerModel, Player.class);
	}

	@Override
	public PlayerModel transformPlayerModel(Player player) {
		if (player == null) {
			return null; 
		}
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(player, PlayerModel.class);
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

	@Override
	public void addImagenPlayer(Player player, String direfichero, MultipartFile multimediaFile,
			RedirectAttributes flash) {
		Path directory = Paths.get(direfichero);
        if (!Files.exists(directory)) {
            try {
				Files.createDirectories(directory);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }
	
		if (multimediaFile != null && !multimediaFile.isEmpty()) {
			// Guarda el archivo en el directorio especificado
			Path rutalogo = Paths.get(direfichero + multimediaFile.getOriginalFilename());
			try {
				Files.write(rutalogo, multimediaFile.getBytes());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			player.setImage("/imgs/players/" + multimediaFile.getOriginalFilename());
		}
		
	}

	public boolean existsInThisClub(int dorsal, int id_team) {
		List<PlayerModel> players=listAllPlayers();
		for (PlayerModel player : players) {
            if (player.getDorsal() == dorsal && player.getId_team() == id_team) {
                return true; 
            }
        }
        return false; 
	}

}
