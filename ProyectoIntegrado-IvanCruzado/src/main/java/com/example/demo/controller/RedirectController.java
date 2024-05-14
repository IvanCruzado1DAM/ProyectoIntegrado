package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/")
public class RedirectController {

	@GetMapping("")
	public String redirectLogin() {
		return "redirect:/auth/login";
	}
	@GetMapping("error")
	public String handleError() {
        // Aquí puedes redirigir al usuario a la página que desees, por ejemplo:
        return "redirect:/home/index";
    }
}
