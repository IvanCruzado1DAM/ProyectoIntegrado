package com.example.demo.controller;

import java.io.IOException;
import java.util.Base64;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
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

	private static final String SHOWDRINKS_VIEW = "showdrinks";
	private static final String EDITDRINK_VIEW = "editdrink";
	private static final String REGISTERNEWDRINK_VIEW = "registernewdrink";

	@Autowired
	@Qualifier("userService")
	private UserServiceImpl userService;

	@Autowired
	@Qualifier("drinkService")
	private DrinkServiceImpl drinkService;
	
	//Show

	@GetMapping("/showDrinks")
	public ModelAndView showDrinks(Model model) {
		String userName = userService.getCurrentUsername();
		List<DrinkModel> drinks = drinkService.listAllDrinks();

		// Agrupar bebidas por categoría
		Map<String, List<DrinkModel>> drinksByCategory = drinks.stream()
				.collect(Collectors.groupingBy(DrinkModel::getDrinkcategory));
		
		for (DrinkModel drink : drinks) {
	        if (drink.getDrinkimage() != null) {
	            String base64Image = Base64.getEncoder().encodeToString(drink.getDrinkimage());
	            String imageUrl = "data:image/jpeg;base64," + base64Image; // Asegúrate de usar el tipo correcto
	            drink.setImageUrl(imageUrl); // Asumiendo que has añadido un campo imageUrl en DrinkModel
	        }
	    }

		ModelAndView mav = new ModelAndView(SHOWDRINKS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("drinksByCategory", drinksByCategory); // Añadimos el mapa al modelo
		return mav;
	}
	
	//Register 
	
	@GetMapping("/newDrink")
	public ModelAndView newDrink(Model model) {
		String userName = userService.getCurrentUsername();
		Map<String, List<DrinkModel>> drinksByCategory = drinkService.listAllDrinks().stream()
				.collect(Collectors.groupingBy(DrinkModel::getDrinkcategory));
		ModelAndView mav = new ModelAndView(REGISTERNEWDRINK_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("newdrink", new Drink());
		mav.addObject("drinksByCategory", drinksByCategory);
		return mav;
	}

	@PostMapping("/saveNewDrink")
	public String registerNewDrink(@ModelAttribute("newdrink") DrinkModel newdrink,
	                               @RequestParam("drinkImageFile") MultipartFile drinkimage,
	                               RedirectAttributes flash) {
	    System.out.println("Recibiendo nueva bebida: " + newdrink);
	    System.out.println("Holaaaaaa 1 - antes de verificar si la bebida ya existe");

	    try {
	        // Verificar si ya existe una bebida con el mismo nombre
	        if (drinkService.findDrinkByDrinkname(newdrink.getDrinkname()) != null) {
	            flash.addFlashAttribute("error", "Drink already exists!");
	            return "redirect:/admin/showDrinks";
	        }

	        // Manejar el archivo de imagen
	        if (!drinkimage.isEmpty()) {
	            System.out.println("Holaaaaaa 1 - Procesando imagen");
	            // Convertir MultipartFile a byte[]
	            byte[] imageData = drinkimage.getBytes();
	            newdrink.setDrinkimage(imageData); // Asignar la imagen como byte[]
	        } else {
	            flash.addFlashAttribute("error", "Image is required!");
	            return "redirect:/admin/newDrink";
	        }

	        // Guardar el objeto de DrinkModel
	        System.out.println("Holaaaaaa 3 - antes de transformar el Drink");
	        drinkService.addDrink(newdrink);
	        System.out.println("Holaaaaaa 3 - bebida guardada con éxito");

	        flash.addFlashAttribute("success", "Drink registered successfully!");
	    } catch (Exception e) {
	        System.out.println("Holaaaaaa 4 - Error al registrar la bebida");
	        flash.addFlashAttribute("error", "An error occurred while registering the drink. Please try again.");
	        e.printStackTrace();
	        return "redirect:/admin/newDrink";
	    }

	    return "redirect:/admin/showDrinks"; // Redirigir a la lista de bebidas tras el éxito
	}
	
	//Delete

	@GetMapping("/deleteDrink/{id}")
	public String deleteDrink(@PathVariable("id") int id, RedirectAttributes flash) {
		if(drinkService.exists(id)) {
			drinkService.removeDrink(id);
			flash.addFlashAttribute("success", "Drink delete successfully!");
		}else {
			flash.addFlashAttribute("error", "Fail removing this drink!");
		}
		return "redirect:/admin/showDrinks";
	}
	
	//Edit

	@GetMapping("/editDrink/{id}")
	public ModelAndView updateTeam(@PathVariable("id") int id, RedirectAttributes flash) {
		String userName = userService.getCurrentUsername();
		Drink drink=drinkService.loadDrinkById(id);
		DrinkModel d=drinkService.transformDrinkModel(drink);
		Map<String, List<DrinkModel>> drinksByCategory = drinkService.listAllDrinks().stream()
				.collect(Collectors.groupingBy(DrinkModel::getDrinkcategory));
		ModelAndView mav = new ModelAndView(EDITDRINK_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("drink", d);
		mav.addObject("drinksByCategory", drinksByCategory);
		return mav;
	}
	
	@PostMapping("/editDrink/update/{id}")
	public String updateeditDrink(@PathVariable("id") int id, RedirectAttributes flash, @ModelAttribute DrinkModel model) {
	    try {
	        // Handle the conversion from MultipartFile to byte[]
	        if (model.getDrinkImageFile() != null && !model.getDrinkImageFile().isEmpty()) {
	            model.setDrinkimage(model.getDrinkImageFile().getBytes());
	        }

	        if (drinkService.exists(id)) {
	            drinkService.updateDrink(id, model);
	            flash.addFlashAttribute("success", "Drink updated successfully!");
	        } else {
	            flash.addFlashAttribute("error", "Fail updating this drink!");
	        }
	    } catch (IOException e) {
	        flash.addFlashAttribute("error", "Error processing the image.");
	    }
	    return "redirect:/admin/showDrinks";
	}



	

}
