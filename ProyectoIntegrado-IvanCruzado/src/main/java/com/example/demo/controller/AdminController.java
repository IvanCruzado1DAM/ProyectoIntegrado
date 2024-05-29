package com.example.demo.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.entity.Coach;
import com.example.demo.entity.Dietist;
import com.example.demo.entity.Game;
import com.example.demo.entity.Multimedia;
import com.example.demo.entity.Physio;
import com.example.demo.entity.Player;
import com.example.demo.entity.President;
import com.example.demo.entity.Team;
import com.example.demo.entity.User;
import com.example.demo.model.CoachModel;
import com.example.demo.model.DietistModel;
import com.example.demo.model.GameModel;
import com.example.demo.model.MultimediaModel;
import com.example.demo.model.PhysioModel;
import com.example.demo.model.PlayerModel;
import com.example.demo.model.PresidentModel;
import com.example.demo.model.TeamModel;
import com.example.demo.repository.UserRepository;
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
@RequestMapping("/admin")
public class AdminController {

	private static final String REGISTERUSERS_VIEW = "registerallusers";
	private static final String REGISTERTEAM_VIEW = "registerteam";
	private static final String REGISTERMULTIMEDIA_VIEW = "registermultimedia";
	private static final String REGISTERMULTIMEDIAVIDEO_VIEW = "registermultimediaVideo";
	private static final String REGISTERNEWUSER_VIEW = "registernewuser";
	private static final String REGISTERNEWPHYSIO_VIEW = "registernewphysio";
	private static final String REGISTERNEWDIETIST_VIEW = "registernewdietist";
	private static final String REGISTERNEWCOACH_VIEW = "registernewcoach";
	private static final String REGISTERNEWPRESIDENT_VIEW = "registernewpresident";
	private static final String REGISTERNEWGAME_VIEW = "registernewgame";
	private static final String REGISTERNEWPLAYER_VIEW = "registernewplayer";

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
	@Qualifier("userRepository")
	private UserRepository userRepository;

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

	@GetMapping("/registerteam")
	public ModelAndView registerteam(Model model) {
		String userName = userService.getCurrentUsername();
		List<CoachModel> coachs = coachService.listAllCoachs();
		List<PresidentModel> presidents = presidentService.listAllPresidents();
		ModelAndView mav = new ModelAndView(REGISTERTEAM_VIEW);
		mav.addObject("team", new Team());
		mav.addObject("coachs", coachs);
		mav.addObject("presidents", presidents);
		mav.addObject("usuario", userName);
		return mav;
	}

	@PostMapping("/admin/registerNewTeam")
	public String registerNewTeam(@ModelAttribute("team") Team team, RedirectAttributes flash,
			@RequestParam("badgeFile") MultipartFile badgeFile) {
		String direfichero = "src/main/resources/static/imgs/escudos/";
		try {
			// Verifica si se ha subido un archivo de escudo
			if (!badgeFile.isEmpty()) {
				// Guarda el archivo en el directorio especificado
				Path rutalogo = Paths.get(direfichero + badgeFile.getOriginalFilename());
				Files.write(rutalogo, badgeFile.getBytes());
				System.out.println(badgeFile.getOriginalFilename());
				team.setBadge("/imgs/escudos/" + badgeFile.getOriginalFilename());
			}

			// Guarda el equipo en la base de datos
			TeamModel t = teamService.transformTeamModel(team);
			teamService.addTeam(t);

			flash.addFlashAttribute("success", "Team registered successfully!");
		} catch (Exception e) {
			flash.addFlashAttribute("error", "An error occurred while registering the team. Please try again.");
			e.printStackTrace();
			return "redirect:/registerteam"; // Redirige a la página de registro si hay un error
		}

		return "redirect:/home/index"; // Redirige a la página principal después del registro exitoso
	}

	@GetMapping("/registermultimedia")
	public ModelAndView registermultimedia(Model model) {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams = teamService.listAllTeams();
		ModelAndView mav = new ModelAndView(REGISTERMULTIMEDIA_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("multimedia", new Multimedia());
		mav.addObject("teams", teams);
		return mav;
	}

	@PostMapping("/admin/registerNewMultimedia")
	public String registerNewMultimedia(@ModelAttribute("multimedia") Multimedia multimedia, RedirectAttributes flash,
			@RequestParam("multimediaFile") MultipartFile multimediaFile) {
		String direfichero = "src/main/resources/static/imgs/news/";
		try {
			multimediaService.addImageMultimedia(multimedia, multimediaFile, direfichero);
			MultimediaModel m = multimediaService.transformMultimediaModel(multimedia);
			multimediaService.addMultimedia(m);
			flash.addFlashAttribute("success", "Noticia registrada satisfactoriamente!");
		} catch (Exception e) {
			flash.addFlashAttribute("error", "An error occurred while registering the team. Please try again.");
			e.printStackTrace();
			return "redirect:/admin/registermultimedia"; // Redirige a la página de registro si hay un error
		}

		return "redirect:/admin/registermultimedia"; // Redirige a la página principal después del registro exitoso
	}

	@GetMapping("/registermultimediaVideo")
	public ModelAndView registermultimediaVideo(Model model) {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams = teamService.listAllTeams();
		ModelAndView mav = new ModelAndView(REGISTERMULTIMEDIAVIDEO_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("multimedia", new Multimedia());
		mav.addObject("teams", teams);
		return mav;
	}

	@PostMapping("/admin/registerNewMultimediaVideo")
	public String registerNewMultimediaVideo(@ModelAttribute("multimedia") Multimedia multimedia,
			RedirectAttributes flash) {
		MultimediaModel m = multimediaService.transformMultimediaModel(multimedia);
		multimediaService.addMultimedia(m);
		flash.addFlashAttribute("success", "Noticia registrada satisfactoriamente!");

		return "redirect:/admin/registermultimediaVideo"; // Redirige a la página principal después del registro exitoso
	}

	@GetMapping("/registerusers")
	public ModelAndView registerusers() {
		String userName = userService.getCurrentUsername();
		ModelAndView mav = new ModelAndView(REGISTERUSERS_VIEW);
		mav.addObject("usuario", userName);
		return mav;
	}

	@GetMapping("/registerusers/user")
	public ModelAndView registerUser() {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams = teamService.listAllTeams();
		ModelAndView mav = new ModelAndView(REGISTERNEWUSER_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("user", new User());
		mav.addObject("teams", teams);
		return mav;
	}

	@PostMapping("/registerusers/newUser")
	public String register(@ModelAttribute User user, RedirectAttributes flash) {
		try {
			if (!userService.existsByUsername(user.getUsername())) {
				userService.registrar(user);
				flash.addFlashAttribute("success", "Usuario registrado satisfactoriamente!");
			}else {		
				flash.addFlashAttribute("error", "Usuario ya existente!");
			}
		} catch (Exception e) {
			flash.addFlashAttribute("error", "An error occurred while registering the team. Please try again.");
			e.printStackTrace();
			return "redirect:/admin/registerusers/user"; // Redirige a la página de registro si hay un error
		}
	
		return "redirect:/admin/registerusers/user";
	}

	@GetMapping("/registerusers/physio")
	public ModelAndView registerPhysio() {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams = teamService.listAllTeams();
		ModelAndView mav = new ModelAndView(REGISTERNEWPHYSIO_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("user", new Physio());
		mav.addObject("teams", teams);
		return mav;
	}

	@PostMapping("/registerusers/newPhysio")
	public String registerPhysio(@ModelAttribute Physio user, RedirectAttributes flash) {
		PhysioModel p = physioService.transformPhysioModel(user);
		physioService.addPhysio(p);
		flash.addFlashAttribute("success", "Fisio registrado satisfactoriamente!");
		return "redirect:/admin/registerusers/physio";
	}

	@GetMapping("/registerusers/dietist")
	public ModelAndView registerDietist() {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams = teamService.listAllTeams();
		ModelAndView mav = new ModelAndView(REGISTERNEWDIETIST_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("user", new Dietist());
		mav.addObject("teams", teams);
		return mav;
	}

	@PostMapping("/registerusers/newDietist")
	public String registerDietist(@ModelAttribute Dietist user, RedirectAttributes flash) {
		DietistModel d = dietistService.transformDietistModel(user);
		dietistService.addDietist(d);
		flash.addFlashAttribute("success", "Dietista registrado satisfactoriamente!");
		return "redirect:/admin/registerusers/dietist";
	}

	@GetMapping("/registerusers/coach")
	public ModelAndView registercoach(Model model) {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams = teamService.listAllTeams();
		ModelAndView mav = new ModelAndView(REGISTERNEWCOACH_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("coach", new Coach());
		mav.addObject("teams", teams);
		return mav;
	}

	@PostMapping("/registerusers/newCoach")
	public String registerNewCoach(@ModelAttribute("coach") Coach coach, RedirectAttributes flash,
			@RequestParam("photoFile") MultipartFile multimediaFile) {
		String direfichero = "src/main/resources/static/imgs/coachs/";
		try {
			coachService.guardarImagen(coach,direfichero, multimediaFile, flash);
			CoachModel c = coachService.transformCoachModel(coach);
			if (!coachService.exists(c, flash)) {
				coachService.addCoach(c);
				flash.addFlashAttribute("success", "Entrenador registrado satisfactoriamente!");
			}
		} catch (Exception e) {
			flash.addFlashAttribute("error", "An error occurred while registering the team. Please try again.");
			e.printStackTrace();
			return "redirect:/admin/registerusers/coach"; // Redirige a la página de registro si hay un error
		}

		return "redirect:/admin/registerusers/coach"; // Redirige a la página principal después del registro exitoso
	}

	@GetMapping("/registerusers/president")
	public ModelAndView registerpresident(Model model) {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams = teamService.listAllTeams();
		ModelAndView mav = new ModelAndView(REGISTERNEWPRESIDENT_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("president", new President());
		mav.addObject("teams", teams);
		if (model.containsAttribute("error")) {
			mav.addObject("error", model.asMap().get("error"));
		}
		return mav;
	}

	@PostMapping("/registerusers/newPresident")
	public String registerNewPresident(@ModelAttribute("president") President presi, RedirectAttributes flash,
			@RequestParam("imageFile") MultipartFile multimediaFile) {
		String direfichero = "src/main/resources/static/imgs/presidents/";
		try {
			presidentService.guardarImagen(presi,direfichero, multimediaFile, flash);
			PresidentModel p = presidentService.transformPresidentModel(presi);
			if (!presidentService.exists(p, flash)) {
	            presidentService.addPresident(p);
	            flash.addFlashAttribute("success", "Presidente registrado satisfactoriamente!");
	        }
		} catch (Exception e) {
			flash.addFlashAttribute("error", "An error occurred while registering the president. Please try again.");
			e.printStackTrace();
			return "redirect:/admin/registerusers/president"; // Redirige a la página de registro si hay un error
		}

		return "redirect:/admin/registerusers/president"; // Redirige a la página principal después del registro exitoso
	}
	
	@GetMapping("/registerusers/game")
	public ModelAndView registergame(Model model) {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams = teamService.listAllTeams();
		ModelAndView mav = new ModelAndView(REGISTERNEWGAME_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("game", new Game());
		mav.addObject("teams", teams);
		return mav;
	}
	
	@PostMapping("/registerusers/newGame")
	public String registerNewGame(@ModelAttribute Game game, RedirectAttributes flash,@RequestParam("date") String dateString, RedirectAttributes redirectAttributes) throws ParseException {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS");
        Date parsedDate = dateFormat.parse(dateString);
        Timestamp timestamp = new Timestamp(parsedDate.getTime());
        game.setDate(timestamp);
		GameModel g = gameService.transformGameModel(game);
		gameService.addGame(g);
		flash.addFlashAttribute("success", "Game registered successfully!");
		return "redirect:/admin/registerusers/game";
	}
	
	@GetMapping("/registerusers/player")
	public ModelAndView registerplayer(Model model) {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams = teamService.listAllTeams();
		ModelAndView mav = new ModelAndView(REGISTERNEWPLAYER_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("player", new Player());
		mav.addObject("teams", teams);
		return mav; 
	}
	
	@PostMapping("/registerusers/newPlayer")
	public String registerNewPlayer(@ModelAttribute("player") Player player, RedirectAttributes flash,
			@RequestParam("imageFile") MultipartFile multimediaFile, @RequestParam(value = "injured", required = false, defaultValue = "false") boolean injured,
            @RequestParam(value = "sancionated", required = false, defaultValue = "false") boolean sancionated) {
		String direfichero = "src/main/resources/static/imgs/players/sevillafc/";
		try {
			 Path directory = Paths.get(direfichero);
	         if (!Files.exists(directory)) {
	             Files.createDirectories(directory);
	         }
			/*TeamModel team = teamService.findById(player.getIdteampresident());
			President existingPresident = presidentService.findByIdteam_president(team.getId_team());
			if (existingPresident != null) {
				flash.addFlashAttribute("error", "There is already a president for this team.");
				return "redirect:/admin/registerusers/president";
			}*/
			// Verifica si se ha subido un archivo de escudo
			if (multimediaFile != null && !multimediaFile.isEmpty()) {
				// Guarda el archivo en el directorio especificado
				Path rutalogo = Paths.get(direfichero + multimediaFile.getOriginalFilename());
				Files.write(rutalogo, multimediaFile.getBytes());
				player.setImage("/imgs/players/sevillafc/" + multimediaFile.getOriginalFilename());
			}

			// Guarda el equipo en la base de datos
			player.set_injured(injured);
	        player.set_sancionated(sancionated);
			PlayerModel p = playerService.transformPlayerModel(player);
			playerService.addPlayer(p);

			flash.addFlashAttribute("success", "President registered successfully!");
		} catch (Exception e) {
			flash.addFlashAttribute("error", e.getMessage());
			e.printStackTrace();
			return "redirect:/admin/registerusers/player"; // Redirige a la página de registro si hay un error
		}

		return "redirect:/admin/registerusers/player"; // Redirige a la página principal después del registro exitoso
	}
}
