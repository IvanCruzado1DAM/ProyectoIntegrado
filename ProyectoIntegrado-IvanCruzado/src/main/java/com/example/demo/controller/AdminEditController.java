package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.model.CoachModel;
import com.example.demo.model.DietistModel;
import com.example.demo.model.GameModel;
import com.example.demo.model.PhysioModel;
import com.example.demo.model.PlayerModel;
import com.example.demo.model.PresidentModel;
import com.example.demo.model.TeamModel;
import com.example.demo.model.UserModel;
import com.example.demo.service.impl.CoachServiceImpl;
import com.example.demo.service.impl.DietistServiceImpl;
import com.example.demo.service.impl.GameServiceImpl;
import com.example.demo.service.impl.MultimediaServiceImpl;
import com.example.demo.service.impl.PhysioServiceImpl;
import com.example.demo.service.impl.PlayerServiceImpl;
import com.example.demo.service.impl.PresidentServiceImpl;
import com.example.demo.service.impl.TeamServiceImpl;
import com.example.demo.service.impl.UserServiceImpl;

@Controller
@RequestMapping("/adminedit")
public class AdminEditController {
	
	private static final String SHOWUSERS_VIEW="/adminshow/showusers";
	private static final String SHOWPLAYERS_VIEW="/adminshow/showplayers";
	private static final String SHOWTEAMS_VIEW="/adminshow/showteams";
	private static final String SHOWCOACHS_VIEW="/adminshow/showcoachs";
	private static final String SHOWPRESIDENTS_VIEW="/adminshow/showpresidents";
	private static final String SHOWGAMES_VIEW="/adminshow/showmatchs";
	private static final String SHOWPHYSIOS_VIEW="/adminshow/showphysios";
	private static final String SHOWDIETISTS_VIEW="/adminshow/showdietists";

	@Autowired
	@Qualifier("userService")
	private UserServiceImpl userService;

	@Autowired
	@Qualifier("multiService")
	private MultimediaServiceImpl multimediaService;

	@Autowired
	@Qualifier("coachService")
	private CoachServiceImpl coachService;

	@Autowired
	@Qualifier("presidentService")
	private PresidentServiceImpl presidentService;

	@Autowired
	@Qualifier("teamService")
	private TeamServiceImpl teamService;

	@Autowired
	@Qualifier("physioService")
	private PhysioServiceImpl physioService;

	@Autowired
	@Qualifier("dietistService")
	private DietistServiceImpl dietistService;
	
	@Autowired
	@Qualifier("gameService")
	private GameServiceImpl gameService;
	
	@Autowired
	@Qualifier("playerService")
	private PlayerServiceImpl playerService;
	
	@GetMapping("/showUsers")
	public ModelAndView showUsers(Model model) {
		String userName = userService.getCurrentUsername();
		List<UserModel> users=userService.listAllUsers();
		List<TeamModel> teams=teamService.listAllTeams();
		ModelAndView mav = new ModelAndView(SHOWUSERS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("users", users);
		mav.addObject("teams", teams);
		return mav;
	}
	
	@GetMapping("/deleteUser/{id}")
	public String deleteUser(@PathVariable("id") int id, RedirectAttributes flash) {
		if(userService.exists(userService.loadUserById(id).getId_user())) {
			userService.removeUser(id);
			flash.addFlashAttribute("success", "User delete successfully!");
		}else {
			flash.addFlashAttribute("error", "Fail removing this user!");
		}
		return "redirect:/adminedit/showUsers";
	}
	
	@GetMapping("/showTeams")
	public ModelAndView showTeams(Model model) {
		String userName = userService.getCurrentUsername();
		List<CoachModel> coachs=coachService.listAllCoachs();
		List<PresidentModel> presidents=presidentService.listAllPresidents();
		List<TeamModel> teams=teamService.listAllTeams();
		ModelAndView mav = new ModelAndView(SHOWTEAMS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("teams", teams);
		mav.addObject("coachs", coachs);
		mav.addObject("presidents", presidents);
		return mav;
	}
	
	@GetMapping("/deleteTeam/{id}")
	public String deleteTeam(@PathVariable("id") int id, RedirectAttributes flash) {
		if(teamService.exists(teamService.findById(id))) {
			teamService.removeTeam(id);
			flash.addFlashAttribute("success", "Team delete successfully!");
		}else {
			flash.addFlashAttribute("error", "Fail removing this team!");
		}
		return "redirect:/adminedit/showTeams";
	}
	
	@GetMapping("/showPhysios")
	public ModelAndView showPhysio(Model model) {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams=teamService.listAllTeams();
		List<PhysioModel> physios=physioService.listAllPhysios();
		ModelAndView mav = new ModelAndView(SHOWPHYSIOS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("physios", physios);
		mav.addObject("teams", teams);
		return mav;
	}
	
	@GetMapping("/deletePhysio/{id}")
	public String deletePhysio(@PathVariable("id") int id, RedirectAttributes flash) {
		if(physioService.exists(id)) {
			physioService.removePhysio(id);
			flash.addFlashAttribute("success", "Physio delete successfully!");
		}else {
			flash.addFlashAttribute("error", "Fail removing this physio!");
		}
		return "redirect:/adminedit/showPhysios";
	}
	
	@GetMapping("/showDietists")
	public ModelAndView showDietists(Model model) {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams=teamService.listAllTeams();
		List<DietistModel> dietists=dietistService.listAllDietist();
		ModelAndView mav = new ModelAndView(SHOWDIETISTS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("dietists", dietists);
		mav.addObject("teams", teams);
		return mav;
	}
	
	@GetMapping("/deleteDietist/{id}")
	public String deleteDietist(@PathVariable("id") int id, RedirectAttributes flash) {
		if(dietistService.exists(id)) {
			dietistService.removeDietist(id);
			flash.addFlashAttribute("success", "Dietist delete successfully!");
		}else {
			flash.addFlashAttribute("error", "Fail removing this dietist!");
		}
		return "redirect:/adminedit/showDietists";
	}
	
	@GetMapping("/showMatchs")
	public ModelAndView showGames(Model model) {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams=teamService.listAllTeams();
		List<GameModel> matches=gameService.listAllGames();
 		ModelAndView mav = new ModelAndView(SHOWGAMES_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("teams", teams);
		mav.addObject("matches", matches);
		return mav;
	}
	
	@GetMapping("/deleteMatch/{id}")
	public String deleteMatch(@PathVariable("id") int id, RedirectAttributes flash) {
		if(gameService.exists(id)) {
			gameService.removeGame(id);
			flash.addFlashAttribute("success", "Game delete successfully!");
		}else {
			flash.addFlashAttribute("error", "Fail removing this game!");
		}
		return "redirect:/adminedit/showMatchs";
	}
	
	
	
	@GetMapping("/showCoachs")
	public ModelAndView showCoachs(Model model) {
		String userName = userService.getCurrentUsername();
		List<CoachModel> coachs=coachService.listAllCoachs();
		List<TeamModel> teams=teamService.listAllTeams();
		ModelAndView mav = new ModelAndView(SHOWCOACHS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("teams", teams);
		mav.addObject("coachs", coachs);
		return mav;
	}
	
	@GetMapping("/deleteCoach/{id}")
	public String deleteCoach(@PathVariable("id") int id, RedirectAttributes flash) {
		if(coachService.exists(id)) {
			coachService.removeCoach(id);
			flash.addFlashAttribute("success", "Coach delete successfully!");
		}else {
			flash.addFlashAttribute("error", "Fail removing this coach!");
		}
		return "redirect:/adminedit/showCoachs";
	}
	@GetMapping("/showPresidents")
	public ModelAndView showPresidents(Model model) {
		String userName = userService.getCurrentUsername();
		List<PresidentModel> presidents=presidentService.listAllPresidents();
		List<TeamModel> teams=teamService.listAllTeams();
		ModelAndView mav = new ModelAndView(SHOWPRESIDENTS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("teams", teams);
		mav.addObject("presidents", presidents);
		return mav;
	}
	
	@GetMapping("/deletePresident/{id}")
	public String deletePresident(@PathVariable("id") int id, RedirectAttributes flash) {
		if(presidentService.exists(id)) {
			presidentService.removePresident(id);
			flash.addFlashAttribute("success", "President delete successfully!");
		}else {
			flash.addFlashAttribute("error", "Fail removing this president!");
		}
		return "redirect:/adminedit/showPresidents";
	}
	
	@GetMapping("/showPlayers")
	public ModelAndView showPlayers(Model model) {
		String userName = userService.getCurrentUsername();
		List<PlayerModel> players=playerService.listAllPlayers();
		List<TeamModel> teams=teamService.listAllTeams();
		ModelAndView mav = new ModelAndView(SHOWPLAYERS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("teams", teams);
		mav.addObject("players", players);
		return mav;
	}
	
	@GetMapping("/deletePlayer/{id}")
	public String deletePlayer(@PathVariable("id") int id, RedirectAttributes flash) {
		if(playerService.exists(id)) {
			playerService.removePlayer(id);
			flash.addFlashAttribute("success", "Player delete successfully!");
		}else {
			flash.addFlashAttribute("error", "Fail removing this player!");
		}
		return "redirect:/adminedit/showPlayers";
	}
	
	
	
	
}
