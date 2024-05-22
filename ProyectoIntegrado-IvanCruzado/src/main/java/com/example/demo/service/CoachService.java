package com.example.demo.service;

import java.util.List;

import com.example.demo.entity.Coach;
import com.example.demo.entity.Player;
import com.example.demo.model.CoachModel;
import com.example.demo.model.PlayerModel;

public interface CoachService {
	
	public abstract List<CoachModel> listAllCoachs();
	
	public abstract Coach addCoach(CoachModel coachModel);

	public abstract int removeCoach(int id);

	public abstract Coach updateCoach(CoachModel coachModel);

	public abstract Coach transformCoach(CoachModel coachModel);

	public abstract CoachModel transformCoachModel(Coach coach);

	public abstract Coach loadCoachById(int id);
	
}
