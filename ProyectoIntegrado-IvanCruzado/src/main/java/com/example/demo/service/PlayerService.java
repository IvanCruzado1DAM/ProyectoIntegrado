package com.example.demo.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.entity.Player;
import com.example.demo.entity.Team;
import com.example.demo.model.CoachModel;
import com.example.demo.model.MultimediaModel;
import com.example.demo.model.PlayerModel;

public interface PlayerService {
	
	public abstract List<PlayerModel> listAllPlayers();
	
	public abstract Player addPlayer(PlayerModel playerModel);

	public abstract int removePlayer(int id);

	public abstract Player updatePlayer(int id, PlayerModel playerModel,MultipartFile multimediaFile, RedirectAttributes flash, boolean injured, boolean sancionated);

	public abstract Player transformPlayer(PlayerModel playerModel);

	public abstract PlayerModel transformPlayerModel(Player player);

	public abstract Player loadPlayerById(int id);
	
	public abstract List<PlayerModel> listAllPlayersbyIdTeam(int idTeam);

	void addImagenPlayer(Player player, String direfichero, MultipartFile multimediaFile, RedirectAttributes flash);
}
