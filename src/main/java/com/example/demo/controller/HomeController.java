package com.example.demo.controller;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.entity.User;
import com.example.demo.model.DrinkModel;
import com.example.demo.model.UserModel;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.impl.DrinkServiceImpl;
import com.example.demo.service.impl.UserServiceImpl;

@Controller
@RequestMapping("/home")
public class HomeController {

	private static final String HOME_VIEW = "home";
	private static final String ABOUTUS_VIEW = "aboutus";
	private static final String WHEREAREWE_VIEW = "wherearewe";
	private static final String SHOWDRINKS_VIEW="showdrinks";
	private static final String EDIT_USER = "updateuser";

	@Autowired
	@Qualifier("userService")
	private UserServiceImpl userService;

	@Autowired
	@Qualifier("userRepository")
	private UserRepository userRepository;

	@Autowired
	@Qualifier("drinkService")
	private DrinkServiceImpl drinkService;
	

	@GetMapping("/index")
	public ModelAndView index() {
		String userName = userService.getCurrentUsername();
		ModelAndView mav = new ModelAndView(HOME_VIEW);
		mav.addObject("usuario", userName);
		return mav;
	}

	@GetMapping("/wherearewe")
	public ModelAndView contacto() {
		String userName = userService.getCurrentUsername();
		ModelAndView mav = new ModelAndView(WHEREAREWE_VIEW);
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


	@GetMapping("/editUser")
	public ModelAndView editUser() {
		ModelAndView mav = new ModelAndView(EDIT_USER);
		String username = userService.getCurrentUsername();
		System.out.println(username);
		User usuario = userRepository.findByUsername(username);
		System.out.println(usuario);
		mav.addObject("id_user", usuario.getIduser());
		mav.addObject("usuario", usuario);
		return mav;
	}

	@PostMapping("/editUser/edit/{id_user}")
	public String updateUsereditado(@PathVariable("id_user") int id, @ModelAttribute UserModel usuario) {
	    userService.updateUser(usuario);
	    return "redirect:/auth/login";

	}
	
	@GetMapping("/showDrinks")
	public ModelAndView showDrinks(Model model) {
	    String userName = userService.getCurrentUsername();
	    List<DrinkModel> drinks = drinkService.listAllDrinks();
	    Map<String, List<DrinkModel>> drinksByCategory = drinks.stream()
	        .collect(Collectors.groupingBy(DrinkModel::getDrinkcategory));
	    
	    ModelAndView mav = new ModelAndView(SHOWDRINKS_VIEW);
	    mav.addObject("usuario", userName);
	    mav.addObject("drinksByCategory", drinksByCategory); // Añadimos el mapa al modelo
	    return mav;
	}
}
