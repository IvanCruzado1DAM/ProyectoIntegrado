package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.entity.User;
import com.example.demo.service.impl.UserServiceImpl;

@Controller
@RequestMapping("/admin")
public class AdminController {

	private static final String REGISTERUSERS_VIEW = "registerallusers";
	private static final String EDITUSERS_VIEW = "editallusers";
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

	

	

	@GetMapping("/registerusers/user")
	public ModelAndView registerUser() {
		String userName = userService.getCurrentUsername();		
		ModelAndView mav = new ModelAndView(REGISTERNEWUSER_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("user", new User());
		return mav;
	}

	@PostMapping("/registerusers/newUser")
	public String register(@ModelAttribute User user, RedirectAttributes flash) {
		try {
			if (!userService.existsByUsername(user.getUsername())) {
				userService.adminregistrar(user);
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

	
}
