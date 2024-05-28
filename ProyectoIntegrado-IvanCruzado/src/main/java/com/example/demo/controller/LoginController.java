package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.entity.User;
import com.example.demo.model.TeamModel;
import com.example.demo.service.impl.TeamServiceImpl;
import com.example.demo.service.impl.UserServiceImpl;

@Controller
public class LoginController {
	private final static String LOGIN_VIEW = "login";
	private final static String REGISTER_VIEW = "register";
	@Autowired
	@Qualifier("userService")
	private UserServiceImpl userService;

	@Autowired
	@Qualifier("teamService")
	private TeamServiceImpl teamService;

	@GetMapping("/auth/login")
	public ModelAndView login(Model model, @RequestParam(name = "error", required = false) String error,
			@RequestParam(name = "logout", required = false) String logout) {
		ModelAndView mav = new ModelAndView(LOGIN_VIEW);
		mav.addObject("usuario", new User());
		mav.addObject("logout", logout);
		mav.addObject("error", error);
		
		if (logout != null) {
			mav.addObject("logoutMessage", "¡Has cerrado sesión correctamente!");
		}
		if (error != null) {
			mav.addObject("loginError", "¡Credenciales Incorrectas!");
		}
		return mav;
	}

	@GetMapping("/auth/registerForm")
	public ModelAndView registerForm(Model model) {
		ModelAndView mav = new ModelAndView(REGISTER_VIEW);
		List<TeamModel> teams = teamService.listAllTeams();
		mav.addObject("user", new User());
		mav.addObject("teams", teams);
		return mav;
	}

	@PostMapping("/auth/register")
	public String register(@ModelAttribute User user, RedirectAttributes flash) {
		if (userService.existsByUsername(user.getUsername())) {
	        flash.addFlashAttribute("error", "Username already exists.");
	        return "redirect:/auth/registerForm";
	    }
		userService.registrar(user);
		flash.addFlashAttribute("success", "User registered successfully!");
		return "redirect:/auth/login";
	}
}
