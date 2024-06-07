package com.example.demo.controllerAPI;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.model.UserModel;
import com.example.demo.service.impl.UserServiceImpl;

@RestController
@RequestMapping("/api")
public class LoginControllerAPI {
	
	@Autowired
	@Qualifier("userService")
	private UserServiceImpl userService;
	
	@GetMapping("/users")
	public List<UserModel> getUsers() {
		List<UserModel> users= userService.listAllUsers();
		return users;
	}
}
