package com.example.demo.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.ResponseEntity;
import org.springframework.http.ResponseEntity;
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
import com.example.demo.entity.Event;
import com.example.demo.entity.Offer;
import com.example.demo.model.CvModel;
import com.example.demo.model.DrinkModel;
import com.example.demo.model.EventModel;
import com.example.demo.model.OfferModel;
import com.example.demo.service.impl.CVServiceImpl;
import com.example.demo.service.impl.DrinkServiceImpl;
import com.example.demo.service.impl.EventServiceImpl;
import com.example.demo.service.impl.OfferServiceImpl;
import com.example.demo.service.impl.UserServiceImpl;

@Controller
@RequestMapping("/admin")
public class AdminController {

	private static final String SHOWDRINKS_VIEW = "showdrinks";
	private static final String SHOWEVENTS_VIEW = "showevents";
	private static final String SHOWOFFERS_VIEW = "showoffers";
	private static final String SHOWCVS_VIEW = "showcvs";
	private static final String EDITDRINK_VIEW = "editdrink";
	private static final String EDITEVENT_VIEW = "editevent";
	private static final String EDITOFFER_VIEW = "editoffer";
	private static final String REGISTERNEWDRINK_VIEW = "registernewdrink";
	private static final String REGISTERNEWEVENT_VIEW = "registernewevent";
	private static final String REGISTERNEWOFFER_VIEW = "registernewoffer";

	@Autowired
	@Qualifier("userService")
	private UserServiceImpl userService;

	@Autowired
	@Qualifier("drinkService")
	private DrinkServiceImpl drinkService;
	
	@Autowired
	@Qualifier("eventService")
	private EventServiceImpl eventService;
	
	@Autowired
	@Qualifier("offerService")
	private OfferServiceImpl offerService;
	
	@Autowired
	@Qualifier("cvService")
	private CVServiceImpl cvService;
	
	//Show

	@GetMapping("/showDrinks")
	public ModelAndView showDrinks(Model model) {
		String userName = userService.getCurrentUsername();
		// Agrupar bebidas por categoría
		Map<String, List<DrinkModel>> drinksByCategory = drinkService.listAllDrinksCategorys();
		drinksByCategory = drinkService.convertImagesToBase64(drinksByCategory);
		ModelAndView mav = new ModelAndView(SHOWDRINKS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("drinksByCategory", drinksByCategory); // Añadimos el mapa al modelo
		return mav;
	}
	
	@GetMapping("/showEvents")
	public ModelAndView showEvents(Model model) {
		String userName = userService.getCurrentUsername();
		List<EventModel> events = eventService.listAllEvents();
		List<EventModel> updatedEvents = eventService.convertImagesToBase64(events);
		ModelAndView mav = new ModelAndView(SHOWEVENTS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("events", updatedEvents);
		return mav;
	}
	
	@GetMapping("/showOffers")
	public ModelAndView showOffers(Model model) {
		String userName = userService.getCurrentUsername();
		List<OfferModel> offers = offerService.listAllOffers();
		ModelAndView mav = new ModelAndView(SHOWOFFERS_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("offers", offers);
		return mav;
	}
	
	@GetMapping("/showCVs")
	public ModelAndView showCVs(Model model) {
		String userName = userService.getCurrentUsername();
		List<CvModel> cvs = cvService.listAllCvs();
	    boolean noCvsAvailable = cvs.isEmpty() || cvs.stream().allMatch(c -> c.isAccept());
		ModelAndView mav = new ModelAndView(SHOWCVS_VIEW);
		mav.addObject("usuario", userName);
	    mav.addObject("noCvsAvailable", noCvsAvailable);
		mav.addObject("cvs", cvs);
		return mav;
	}
	
	//Register 
	
	@GetMapping("/newDrink")
	public ModelAndView newDrink(Model model) {
		String userName = userService.getCurrentUsername();
		Map<String, List<DrinkModel>> drinksByCategory = drinkService.listAllDrinksCategorys();
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
	    try {
	        // Verificar si ya existe una bebida con el mismo nombre
	        if (drinkService.findDrinkByDrinkname(newdrink.getDrinkname()) != null) {
	            flash.addFlashAttribute("error", "Drink already exists!");
	            return "redirect:/admin/showDrinks";
	        }

	        // Manejar el archivo de imagen
	        if (!drinkimage.isEmpty()) {
	            byte[] imageData = drinkimage.getBytes();
	            newdrink.setDrinkimage(imageData); // Asignar la imagen como byte[]
	        } else {
	            flash.addFlashAttribute("error", "Image is required!");
	            return "redirect:/admin/newDrink";
	        }

	        // Guardar el objeto de DrinkModel
	        drinkService.addDrink(newdrink);
	        flash.addFlashAttribute("success", "Drink registered successfully!");
	    } catch (Exception e) {
	        flash.addFlashAttribute("error", "An error occurred while registering the drink. Please try again.");
	        e.printStackTrace();
	        return "redirect:/admin/newDrink";
	    }

	    return "redirect:/admin/showDrinks"; // Redirigir a la lista de bebidas tras el éxito
	}
	
	@GetMapping("/newEvent")
	public ModelAndView newEvent(Model model) {
		String userName = userService.getCurrentUsername();
		ModelAndView mav = new ModelAndView(REGISTERNEWEVENT_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("newevent", new Event());
		return mav;
	}
	
	@PostMapping("/saveNewEvent")
	public String registerNewEvent(@ModelAttribute("newevent") EventModel newevent,
	                               @RequestParam("eventImageFile") MultipartFile eventimage,
	                               RedirectAttributes flash) {
	    try {
	        // Verificar si ya existe una bebida con el mismo nombre
	        if (eventService.findEventByname(newevent.getEventname()) != null) {
	            flash.addFlashAttribute("error", "Event already exists!");
	            return "redirect:/admin/showEvents";
	        }

	        // Manejar el archivo de imagen
	        if (!eventimage.isEmpty()) {
	            byte[] imageData = eventimage.getBytes();
	            newevent.setEventimage(imageData); // Asignar la imagen como byte[]
	        } else {
	            flash.addFlashAttribute("error", "Image is required!");
	            return "redirect:/admin/newEvent";
	        }

	        // Guardar el objeto de DrinkModel
	        eventService.addEvent(newevent);
	        flash.addFlashAttribute("success", "Event registered successfully!");
	    } catch (Exception e) {
	        flash.addFlashAttribute("error", "An error occurred while registering the drink. Please try again.");
	        e.printStackTrace();
	        return "redirect:/admin/newEvent";
	    }

	    return "redirect:/admin/showEvents"; 
	}
	
	@GetMapping("/newOffer")
	public ModelAndView newOffer(Model model) {
		String userName = userService.getCurrentUsername();
		ModelAndView mav = new ModelAndView(REGISTERNEWOFFER_VIEW);
		mav.addObject("usuario", userName);
		mav.addObject("newoffer", new Offer());
		return mav;
	}

	@PostMapping("/saveNewOffer")
	public String registerNewOffer(@ModelAttribute("newoffer") OfferModel newoffer,
	                               RedirectAttributes flash) {
	    try {
	        offerService.addOffer(newoffer);
	        flash.addFlashAttribute("success", "Offer registered successfully!");
	    } catch (Exception e) {
	        flash.addFlashAttribute("error", "An error occurred while registering the offer. Please try again.");
	        e.printStackTrace();
	        return "redirect:/admin/newOffer";
	    }

	    return "redirect:/admin/showOffers"; 
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
	
	@GetMapping("/deleteEvent/{id}")
	public String deleteEvent(@PathVariable("id") int id, RedirectAttributes flash) {
		if(eventService.exists(id)) {
			eventService.removeEvent(id);
			flash.addFlashAttribute("success", "Event delete successfully!");
		}else {
			flash.addFlashAttribute("error", "Fail removing this event!");
		}
		return "redirect:/admin/showEvents";
	}
	
	@GetMapping("/deleteOffer/{id}")
	public String deleteOffer(@PathVariable("id") int id, RedirectAttributes flash) {
		if(offerService.exists(id)) {
			offerService.removeOffer(id);
			flash.addFlashAttribute("success", "Offer delete successfully!");
		}else {
			flash.addFlashAttribute("error", "Fail removing this offer!");
		}
		return "redirect:/admin/showOffers";
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
	
	@GetMapping("/editEvent/{id}")
	public ModelAndView updateEvent(@PathVariable("id") int id, RedirectAttributes flash) {
	    String userName = userService.getCurrentUsername();
	    Event event = eventService.loadEventById(id);
	    EventModel e = eventService.transformEventModel(event);
	    ModelAndView mav = new ModelAndView(EDITEVENT_VIEW);
	    mav.addObject("usuario", userName);
	    mav.addObject("event", e);
	    return mav;
	}

	
	@PostMapping("/editEvent/update/{id}")
	public String updateeditEvent(@PathVariable("id") int id, RedirectAttributes flash, @ModelAttribute EventModel model) {
	    try {
	        if (model.getEventImageFile() != null && !model.getEventImageFile().isEmpty()) {
	            model.setEventimage(model.getEventImageFile().getBytes());
	        }
	        if (eventService.exists(id)) {
	            eventService.updateEvent(id, model);
	            flash.addFlashAttribute("success", "Event updated successfully!");
	        } else {
	            flash.addFlashAttribute("error", "Fail updating this event!");
	        }
	    } catch (IOException e) {
	        flash.addFlashAttribute("error", "Error processing the image.");
	    }
	    return "redirect:/admin/showEvents";
	}
	
	@GetMapping("/editOffer/{id}")
	public ModelAndView updateOffer(@PathVariable("id") int id, RedirectAttributes flash) {
	    String userName = userService.getCurrentUsername();
	    Offer offer = offerService.loadOfferById(id);
	    OfferModel of = offerService.transformOfferModel(offer);
	    ModelAndView mav = new ModelAndView(EDITOFFER_VIEW);
	    mav.addObject("usuario", userName);
	    mav.addObject("offer", of);
	    return mav;
	}

	
	@PostMapping("/editOffer/update/{id}")
	public String updateeditOffer(@PathVariable("id") int id, RedirectAttributes flash, @ModelAttribute OfferModel model) {
	    if (offerService.exists(id)) {
		    offerService.updateOffer(id, model);
		    flash.addFlashAttribute("success", "Offer updated successfully!");
		} else {
		    flash.addFlashAttribute("error", "Fail updating this offer!");
		}
	    return "redirect:/admin/showOffers";
	}
	 
	//CV
	@GetMapping("/acceptCv/{id}")
	public String acceptCv(@PathVariable("id") int id, RedirectAttributes flash, @ModelAttribute CvModel model) {
		if (cvService.exists(id)) {
		    cvService.acceptCv(id, model);
		    flash.addFlashAttribute("success", "Cv acepted successfully!");
		} else {
		    flash.addFlashAttribute("error", "Fail updating this cv!");
		}
	    return "redirect:/admin/showCVs";
	}
	@GetMapping("/readCv/{id}")
	public ResponseEntity<byte[]> readCv(@PathVariable("id") int id, RedirectAttributes flash) {
	    return cvService.getCvFile(id);
	}
	

	

}
