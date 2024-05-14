package com.example.demo.service;

import com.example.demo.entity.User;
import com.example.demo.model.UserModel;
import java.util.List;

import org.springframework.security.core.userdetails.UserDetails;

public interface UserService {

	public abstract List<UserModel> listAllUsers();
	
	public UserDetails loadUserByUsername(String username);
	
	public abstract User addUser(UserModel userModel);

	public abstract int removeUser(int id);

	public abstract User updateUser(UserModel userModel);

	public abstract User transformUser(UserModel userModel);

	public abstract UserModel transformUserModel(User user);

	public abstract int getCurrentUserTeamId(String username);
	
	public abstract User loadUserById(int id);

}
