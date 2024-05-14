package com.example.demo.service;

import java.util.List;

import com.example.demo.model.GameModel;

public interface GameService {
	public abstract List<GameModel> listAllGames(int idTeam);
}
