package com.example.demo.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.entity.Multimedia;
import com.example.demo.entity.Physio;
import com.example.demo.entity.President;
import com.example.demo.entity.Team;
import com.example.demo.entity.User;
import com.example.demo.model.CoachModel;
import com.example.demo.model.MultimediaModel;
import com.example.demo.model.PresidentModel;
import com.example.demo.model.TeamModel;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.impl.CoachServiceImpl;
import com.example.demo.service.impl.MultimediaServiceImpl;
import com.example.demo.service.impl.PresidentServiceImpl;
import com.example.demo.service.impl.TeamServiceImpl;
import com.example.demo.service.impl.UserServiceImpl;

@Controller
@RequestMapping("/admin")
public class AdminController {

	private static final String REGISTERUSER_VIEW = "registeruser";
	private static final String REGISTERTEAM_VIEW = "registerteam";
	private static final String REGISTERMULTIMEDIA_VIEW = "registermultimedia";
	private static final String REGISTERMULTIMEDIAVIDEO_VIEW = "registermultimediaVideo";
	
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

	@GetMapping("/register")
	public ModelAndView register(Model model) {
		String userName = userService.getCurrentUsername();
		List<TeamModel> teams = teamService.listAllTeams();
		ModelAndView mav = new ModelAndView(REGISTERUSER_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("user", new User());
		mav.addObject("teams", teams);
		return mav;
	}
	
	@PostMapping("/registerNewUser")
	public String submitForm(@ModelAttribute("user") User user, BindingResult result, Model model) {
	    if (result.hasErrors()) {
	        model.addAttribute("teams", teamService.listAllTeams());
	        return REGISTERUSER_VIEW;
	    }
	    
	    String userType = user.getUserType();
	    
	    switch (userType) {
	        case "president":
	            President president = new President();
	            // Copia los campos de user a president
	            break;
	        case "physio":
	            Physio physio = new Physio();
	            // Copia los campos de user a physio
	            break;
	        // Maneja otros tipos de usuario de manera similar
	        default:
	            // Lógica para usuario genérico
	            break;
	    }

	    // Guardar el objeto específico en el servicio correspondiente
	    return "redirect:/success";
	}
	
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
	public String registerNewTeam(@ModelAttribute("team") Team team,
	                              RedirectAttributes flash,
	                              @RequestParam("badgeFile") MultipartFile badgeFile) {
	    String direfichero = "src/main/resources/static/imgs/escudos/";
	    try {
	        // Verifica si se ha subido un archivo de escudo
	        if (!badgeFile.isEmpty()) {
	            // Guarda el archivo en el directorio especificado
	            Path rutalogo = Paths.get(direfichero + badgeFile.getOriginalFilename());
	            Files.write(rutalogo, badgeFile.getBytes());
	            System.out.println(badgeFile.getOriginalFilename());
	            team.setBadge("/imgs/escudos/"+badgeFile.getOriginalFilename());
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
	public String registerNewMultimedia(@ModelAttribute("multimedia") Multimedia multimedia,
	                              RedirectAttributes flash,
	                              @RequestParam("multimediaFile") MultipartFile multimediaFile) {
	    String direfichero = "src/main/resources/static/imgs/news/";
	    try {
	        // Verifica si se ha subido un archivo de escudo
	        if (multimediaFile != null && !multimediaFile.isEmpty()) {
	            // Guarda el archivo en el directorio especificado
	            Path rutalogo = Paths.get(direfichero + multimediaFile.getOriginalFilename());
	            Files.write(rutalogo, multimediaFile.getBytes());
	            System.out.println(multimediaFile.getOriginalFilename());
	            multimedia.setImage("/imgs/news/"+multimediaFile.getOriginalFilename());
	        }

	        // Guarda el equipo en la base de datos
	        MultimediaModel m = multimediaService.transformMultimediaModel(multimedia);
	        multimediaService.addMultimedia(m);

	        flash.addFlashAttribute("success", "Multimedia registered successfully!");
	    } catch (Exception e) {
	        flash.addFlashAttribute("error", "An error occurred while registering the team. Please try again.");
	        e.printStackTrace();
	        return "redirect:/registerteam"; // Redirige a la página de registro si hay un error
	    }

	    return "redirect:/home/index"; // Redirige a la página principal después del registro exitoso
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
	        // Guarda el equipo en la base de datos
	        MultimediaModel m = multimediaService.transformMultimediaModel(multimedia);
	        multimediaService.addMultimedia(m);
	        flash.addFlashAttribute("success", "Multimedia registered successfully!");

	    return "redirect:/home/index"; // Redirige a la página principal después del registro exitoso
	}

	
}
