package com.example.demo.controller;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.entity.Drink;
import com.example.demo.entity.User;
import com.example.demo.model.DrinkModel;
import com.example.demo.service.impl.DrinkServiceImpl;
import com.example.demo.service.impl.UserServiceImpl;

@Controller
@RequestMapping("/admin")
public class AdminController {

	private static final String SHOWDRINKS_VIEW="showdrinks";
	private static final String REGISTERNEWDRINK_VIEW = "registernewdrink";
	
	@Autowired
	@Qualifier("userService")
	private UserServiceImpl userService;
	
	@Autowired
	@Qualifier("drinkService")
	private DrinkServiceImpl drinkService;

	@GetMapping("/showDrinks")
	public ModelAndView showDrinks(Model model) {
	    String userName = userService.getCurrentUsername();
	    List<DrinkModel> drinks = drinkService.listAllDrinks();
	    
	    // Agrupar bebidas por categoría
	    Map<String, List<DrinkModel>> drinksByCategory = drinks.stream()
	        .collect(Collectors.groupingBy(DrinkModel::getDrinkcategory));
	    
	    ModelAndView mav = new ModelAndView(SHOWDRINKS_VIEW);
	    mav.addObject("usuario", userName);
	    mav.addObject("drinksByCategory", drinksByCategory); // Añadimos el mapa al modelo
	    return mav;
	}
	
	@GetMapping("/newDrink")
	public ModelAndView registermultimediaVideo(Model model) {
		String userName = userService.getCurrentUsername();
		Map<String, List<DrinkModel>> drinksByCategory = drinkService.listAllDrinks().stream()
		        .collect(Collectors.groupingBy(DrinkModel::getDrinkcategory));
		ModelAndView mav = new ModelAndView(REGISTERNEWDRINK_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("drink", new Drink());
		mav.addObject("drinksByCategory", drinksByCategory);
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

	

	/*@GetMapping("/registerusers/user")
	public ModelAndView registerUser() {
		String userName = userService.getCurrentUsername();		
		ModelAndView mav = new ModelAndView(REGISTERNEWUSER_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("user", new User());
		return mav;
	}*/

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
