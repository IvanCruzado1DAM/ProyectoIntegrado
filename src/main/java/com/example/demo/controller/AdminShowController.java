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

import com.example.demo.model.UserModel;
import com.example.demo.service.impl.UserServiceImpl;

@Controller
@RequestMapping("/adminshow")
public class AdminShowController {
	
	private static final String SHOWUSERS_VIEW="showusers";
	private static final String SHOWPLAYERS_VIEW="showplayers";
	private static final String SHOWTEAMS_VIEW="showteams";
	private static final String SHOWCOACHS_VIEW="showcoachs";
	private static final String SHOWPRESIDENTS_VIEW="showpresidents";
	private static final String SHOWGAMES_VIEW="showmatchs";
	private static final String SHOWPHYSIOS_VIEW="showphysios";
	private static final String SHOWDIETISTS_VIEW="showdietists";
	private static final String SHOWMULTIMEDIAS_VIEW="showmultimedias";

	@Autowired
	@Qualifier("userService")
	private UserServiceImpl userService;

	
	
	
	//Users
	
	@GetMapping("/showUsers")
	public ModelAndView showUsers(Model model) {
		String userName = userService.getCurrentUsername();
		List<UserModel> users=userService.listAllUsers();
		ModelAndView mav = new ModelAndView(SHOWUSERS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("users", users);
		return mav;
	}
	
	/*@GetMapping("/deleteUser/{id}")
	public String deleteUser(@PathVariable("id") int id, RedirectAttributes flash) {
		if(userService.exists(userService.loadUserById(id).getId_user())) {
			userService.removeUser(id);
			flash.addFlashAttribute("success", "User delete successfully!");
		}else {
			flash.addFlashAttribute("error", "Fail removing this user!");
		}
		return "redirect:/adminshow/showUsers";
	}*/
	
	
	
	
}
