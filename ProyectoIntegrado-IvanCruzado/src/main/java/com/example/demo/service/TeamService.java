package com.example.demo.service;

import java.util.List;

import com.example.demo.entity.Team;
import com.example.demo.model.TeamModel;

public interface TeamService {
	
	public abstract List<TeamModel> listAllTeams();
	
	public abstract Team addTeam(TeamModel teamModel);

	public abstract int removeTeam(int id);

	public abstract Team updateTeam(TeamModel teamModel);

	public abstract Team transformTeam(TeamModel teamModel);

	public abstract TeamModel transformTeamModel(Team team);

	public abstract Team loadTeamById(int id);
}
