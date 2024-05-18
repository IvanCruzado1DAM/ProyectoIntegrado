package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.entity.Player;
import com.example.demo.model.GameModel;
import com.example.demo.model.MultimediaModel;
import com.example.demo.model.PlayerModel;
import com.example.demo.model.TeamModel;
import com.example.demo.service.impl.GameServiceImpl;
import com.example.demo.service.impl.MultimediaServiceImpl;
import com.example.demo.service.impl.PlayerServiceImpl;
import com.example.demo.service.impl.TeamServiceImpl;
import com.example.demo.service.impl.UserServiceImpl;

@Controller
@RequestMapping("/yourteam")
public class TeamController {
	private static final String CALENDAR_VIEW = "calendar";
	private static final String MULTIMEDIA_VIEW = "multimedia";
	private static final String PLAYERS_VIEW = "squad";
	private static final String PLAYER_STATS = "playerstats";
	
	@Autowired
	@Qualifier("userService")
	private UserServiceImpl userService;
	
	@Autowired
	@Qualifier("teamService")
	private TeamServiceImpl teamService;
	
	@Autowired
	@Qualifier("gameService")
	private GameServiceImpl gameService;
	
	@Autowired
	@Qualifier("multiService")
	private MultimediaServiceImpl multiService;
	
	@Autowired
	@Qualifier("playerService")
	private PlayerServiceImpl playerService;
	
	@GetMapping("/calendar")
	public ModelAndView calendar() {
		String userName = userService.getCurrentUsername();
		int idUserTeam = userService.getCurrentUserTeamId(userName);
		List<TeamModel> teams=  teamService.listAllTeams();
		List<GameModel> games=  gameService.listAllGames(idUserTeam);	
		ModelAndView mav = new ModelAndView(CALENDAR_VIEW);
		mav.addObject("games", games);
		mav.addObject("teams", teams);
		mav.addObject("usuario", userName);
		return mav;
	}
	
	@GetMapping("/multimedia")
	public ModelAndView multimedia(){
		String userName = userService.getCurrentUsername();
		int idUserTeam = userService.getCurrentUserTeamId(userName);
		List<MultimediaModel> multimedia=  multiService.listAllMultimediabyIdTeam(idUserTeam);	
		ModelAndView mav = new ModelAndView(MULTIMEDIA_VIEW);
		mav.addObject("multi", multimedia);
		mav.addObject("usuario", userName);
		return mav;
	}
	
	@GetMapping("/squad")
	public ModelAndView squad(){
		String userName = userService.getCurrentUsername();
		int idUserTeam = userService.getCurrentUserTeamId(userName);	
		List<PlayerModel> playersteam=  playerService.listAllPlayersbyIdTeam(idUserTeam);	
		ModelAndView mav = new ModelAndView(PLAYERS_VIEW);
		mav.addObject("players", playersteam);
		mav.addObject("usuario", userName);
		return mav;
	}
	
	@GetMapping("/squad/player/{playerId}")
	public ModelAndView getPlayerDetails(@PathVariable("playerId") int playerId) {
	    Player player = playerService.loadPlayerById(playerId);
	    System.out.println(player);
	    String userName = userService.getCurrentUsername();
	    ModelAndView mav = new ModelAndView(PLAYER_STATS);
	    mav.addObject("player", player);
	    mav.addObject("usuario", userName);
	    return mav;
	}

	
}
