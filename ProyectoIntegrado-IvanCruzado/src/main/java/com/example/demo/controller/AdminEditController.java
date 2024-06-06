package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.entity.Coach;
import com.example.demo.entity.Dietist;
import com.example.demo.entity.Game;
import com.example.demo.entity.Physio;
import com.example.demo.entity.Player;
import com.example.demo.entity.President;
import com.example.demo.entity.Team;
import com.example.demo.entity.User;
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
	
	private static final String EDITUSERS_VIEW="/adminedit/edituser";
	private static final String EDITPLAYERS_VIEW="/adminedit/editplayer";
	private static final String EDITTEAMS_VIEW="/adminedit/editteam";
	private static final String EDITCOACHS_VIEW="/adminedit/editcoach";
	private static final String EDITPRESIDENTS_VIEW="/adminedit/editpresident";
	private static final String EDITGAMES_VIEW="/adminedit/editgame";
	private static final String EDITPHYSIOS_VIEW="/adminedit/editphysio";
	private static final String EDITDIETISTS_VIEW="/adminedit/editdietist";

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
	
	//User
	@GetMapping("/updateUser/{id}")
	public ModelAndView updateUser(@PathVariable("id") int id, RedirectAttributes flash) {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams=teamService.listAllTeams();
		User user=userService.loadUserById(id);
		ModelAndView mav = new ModelAndView(EDITUSERS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("user", user);
		mav.addObject("teams", teams);
		return mav;
	}
	
	@PostMapping("/updateUser/update/{id}")
	public String updateeditUser(@PathVariable("id") int id, RedirectAttributes flash, @ModelAttribute UserModel model) {
		if(userService.exists(id)) {
			userService.updateUser(model);
			flash.addFlashAttribute("success", "User update successfully!");
		}else {
			flash.addFlashAttribute("error", "Fail updating this user!");
		}
		return "redirect:/adminshow/showUsers";
	}
	
	//Team
	@GetMapping("/updateTeam/{id}")
	public ModelAndView updateTeam(@PathVariable("id") int id, RedirectAttributes flash) {
		String userName = userService.getCurrentUsername();
		Team team=teamService.loadTeamById(id);
		ModelAndView mav = new ModelAndView(EDITTEAMS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("team", team);
		return mav;
	}
	
	
	@PostMapping("/updateTeam/update/{id}")
	public String updateeditTeam(@PathVariable("id") int id, RedirectAttributes flash, @RequestParam("badgeFile") MultipartFile multimediaFile,  @ModelAttribute TeamModel model) {
		if(teamService.exists(teamService.findById(id))) {
			teamService.updateTeam(id, model, multimediaFile, flash);
		}else {
			flash.addFlashAttribute("error", "Fail updating this team!");
		}
		return "redirect:/adminshow/showTeams";
	}
	
	//Coach 
	
	@GetMapping("/updateCoach/{id}")
	public ModelAndView updateCoach(@PathVariable("id") int id, RedirectAttributes flash) {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams=teamService.listAllTeams();
		Coach coach=coachService.loadCoachById(id);
		ModelAndView mav = new ModelAndView(EDITCOACHS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("coach", coach);
		mav.addObject("teams", teams);
		return mav;
	}
	
	
	@PostMapping("/updateCoach/update/{id}")
	public String updateeditCoach(@PathVariable("id") int id, RedirectAttributes flash, @RequestParam("photoFile") MultipartFile multimediaFile,  @ModelAttribute CoachModel model) {
		if(coachService.existsById(id, flash)) {
			coachService.updateCoach(id, model, multimediaFile, flash);
		}else {
			flash.addFlashAttribute("error", "Fail updating this coach!");
		}
		return "redirect:/adminshow/showCoachs";
	}
	
	//President 
	@GetMapping("/updatePresident/{id}")
	public ModelAndView updatePresident(@PathVariable("id") int id, RedirectAttributes flash) {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams=teamService.listAllTeams();
		President president=presidentService.loadPresidentById(id);
		ModelAndView mav = new ModelAndView(EDITPRESIDENTS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("president", president);
		mav.addObject("teams", teams);
		return mav;
	}
	
	@PostMapping("/updatePresident/update/{id}")
	public String updateeditPresident(@PathVariable("id") int id, RedirectAttributes flash, @RequestParam("imageFile") MultipartFile multimediaFile,  @ModelAttribute PresidentModel model) {
		if(presidentService.existsById(id, flash)) {
			presidentService.updatePresident(id, model, multimediaFile, flash);
		}else {
			flash.addFlashAttribute("error", "Fail updating this coach!");
		}
		return "redirect:/adminshow/showPresidents";
	}
	
	//Player
	@GetMapping("/updatePlayer/{id}")
	public ModelAndView updatePlayer(@PathVariable("id") int id, RedirectAttributes flash) {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams=teamService.listAllTeams();
		Player player=playerService.loadPlayerById(id);
		ModelAndView mav = new ModelAndView(EDITPLAYERS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("player", player);
		mav.addObject("teams", teams);
		return mav;
	}
	
	
	@PostMapping("/updatePlayer/update/{id}")
	public String updateeditPlayer(@PathVariable("id") int id, RedirectAttributes flash, @RequestParam("imageFile") MultipartFile multimediaFile,  
			@ModelAttribute PlayerModel model, @RequestParam(value = "injured", required = false, defaultValue = "false") boolean injured,
            @RequestParam(value = "sancionated", required = false, defaultValue = "false") boolean sancionated) {
		if(playerService.exists(id, flash)) {
			playerService.updatePlayer(id, model, multimediaFile, flash, injured, sancionated);
		}else {
			flash.addFlashAttribute("error", "Fail updating this player!");
		}
		return "redirect:/adminshow/showPlayers";
	}
	
	
	//Game
	
	@GetMapping("/updateGame/{id}")
	public ModelAndView updateGame(@PathVariable("id") int id, RedirectAttributes flash) {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams=teamService.listAllTeams();
		Game match=gameService.loadGameById(id);
 		ModelAndView mav = new ModelAndView(EDITGAMES_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("teams", teams);
		mav.addObject("match", match);
		return mav;
	}
	
	@PostMapping("/updateGame/update/{id}")
	public String updateeditGame(@PathVariable("id") int id, RedirectAttributes flash, @ModelAttribute GameModel model) {
		if(gameService.exists(id)) {
			gameService.updateGame(id, model);
			flash.addFlashAttribute("success", "Match update successfully!");
		}else {
			flash.addFlashAttribute("error", "Fail updating this match!");
		}
		return "redirect:/adminshow/showMatchs";
	}
	
	//Physio
	
	@GetMapping("/updatePhysio/{id}")
	public ModelAndView updatePhysio(@PathVariable("id") int id, RedirectAttributes flash) {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams=teamService.listAllTeams();
		Physio physio=physioService.loadPhysioById(id);
		ModelAndView mav = new ModelAndView(EDITPHYSIOS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("physio", physio);
		mav.addObject("teams", teams);
		return mav;
	}
	
	@PostMapping("/updatePhysio/update/{id}")
	public String updateeditPhysio(@PathVariable("id") int id, RedirectAttributes flash, @ModelAttribute PhysioModel model) {
		if(physioService.exists(id)) {
			physioService.updatePhysio(id, model);
			flash.addFlashAttribute("success", "Physio update successfully!");
		}else {
			flash.addFlashAttribute("error", "Fail updating this physio!");
		}
		return "redirect:/adminshow/showPhysios";
	}
	
	//Dietist
	
	@GetMapping("/updateDietist/{id}")
	public ModelAndView updateDietist(@PathVariable("id") int id, RedirectAttributes flash) {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams=teamService.listAllTeams();
		Dietist dietist=dietistService.loadDietistById(id);
		ModelAndView mav = new ModelAndView(EDITDIETISTS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("dietist", dietist);
		mav.addObject("teams", teams);
		return mav;
	}
	
	@PostMapping("/updateDietist/update/{id}")
	public String updateeditDietist(@PathVariable("id") int id, RedirectAttributes flash, @ModelAttribute DietistModel model) {
		if(dietistService.exists(id)) {
			dietistService.updateDietist(id, model);
			flash.addFlashAttribute("success", "Dietist update successfully!");
		}else {
			flash.addFlashAttribute("error", "Fail updating this dietist!");
		}
		return "redirect:/adminshow/showDietists";
	}
	
	
	
	
	
	
}
