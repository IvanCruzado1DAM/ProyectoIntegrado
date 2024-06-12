package com.example.demo.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.entity.Team;
import com.example.demo.model.CoachModel;
import com.example.demo.model.TeamModel;

public interface TeamService {
	
	public abstract List<TeamModel> listAllTeams();
	
	public abstract Team addTeam(TeamModel teamModel);

	public abstract int removeTeam(int id);

	public abstract Team updateTeam(int id, TeamModel teamModel,MultipartFile multimediaFile, RedirectAttributes flash);

	public abstract Team transformTeam(TeamModel teamModel);

	public abstract TeamModel transformTeamModel(Team team);

	public abstract Team loadTeamById(int id);

	public abstract TeamModel findById(int idteam_president);

	void addBadge(Team team, MultipartFile badgeFile, String direfichero);

	boolean exists(TeamModel t);
}
