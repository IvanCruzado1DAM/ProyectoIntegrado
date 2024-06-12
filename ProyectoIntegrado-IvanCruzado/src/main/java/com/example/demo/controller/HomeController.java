package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.entity.Team;
import com.example.demo.entity.User;
import com.example.demo.model.TeamModel;
import com.example.demo.model.UserModel;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.impl.TeamServiceImpl;
import com.example.demo.service.impl.UserServiceImpl;

@Controller
@RequestMapping("/home")
public class HomeController {

	private static final String HOME_VIEW = "home";
	private static final String ABOUTUS_VIEW = "aboutus";
	private static final String CONTACT_VIEW = "contact";
	private static final String YOURTEAM_VIEW = "yourteam";
	private static final String EDIT_USER = "updateuser";

	@Autowired
	@Qualifier("userService")
	private UserServiceImpl userService;

	@Autowired
	@Qualifier("userRepository")
	private UserRepository userRepository;

	@Autowired
	@Qualifier("teamService")
	private TeamServiceImpl teamService;

	@GetMapping("/index")
	public ModelAndView index() {
		String userName = userService.getCurrentUsername();
		ModelAndView mav = new ModelAndView(HOME_VIEW);
		mav.addObject("usuario", userName);
		return mav;
	}

	@GetMapping("/contactus")
	public ModelAndView contacto() {
		String userName = userService.getCurrentUsername();
		ModelAndView mav = new ModelAndView(CONTACT_VIEW);
		mav.addObject("usuario", userName);
		return mav;
	}

	@GetMapping("/aboutus")
	public ModelAndView sobrenosotros() {
		String userName = userService.getCurrentUsername();
		ModelAndView mav = new ModelAndView(ABOUTUS_VIEW);
		mav.addObject("usuario", userName);
		return mav;
	}

	@GetMapping("/yourteam")
	public ModelAndView tuequipo() {
		String userName = userService.getCurrentUsername();
		int idUserTeam = userService.getCurrentUserTeamId(userName);
		Team userTeam = teamService.loadTeamById(idUserTeam);

		ModelAndView mav = new ModelAndView(YOURTEAM_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("userTeam", userTeam);
		return mav;
	}

	@GetMapping("/editUser")
	public ModelAndView editUser() {
		ModelAndView mav = new ModelAndView(EDIT_USER);
		String username = userService.getCurrentUsername();
		System.out.println(username);
		User usuario = userRepository.findByUsername(username);
		System.out.println(usuario);
		List<TeamModel> teams = teamService.listAllTeams();
		mav.addObject("teams", teams);
		mav.addObject("id_user", usuario.getId_user());
		mav.addObject("usuario", usuario);
		return mav;
	}

	@PostMapping("/editUser/edit/{id_user}")
	public String updateUsereditado(@PathVariable("id_user") int id, @ModelAttribute UserModel usuario) {
	    userService.updateUser(usuario);
	    return "redirect:/auth/login";

	}
}
