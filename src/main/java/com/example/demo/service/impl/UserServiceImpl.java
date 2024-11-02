package com.example.demo.service.impl;


import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User.UserBuilder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.demo.entity.User;
import com.example.demo.model.UserModel;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.UserService;


@Service("userService")
public class UserServiceImpl implements UserDetailsService, UserService {

	@Autowired
	@Qualifier("userRepository")
	private UserRepository userRepository;

	private PasswordEncoder passwordEncoder;
	
    public UserServiceImpl() {
        this.passwordEncoder = new BCryptPasswordEncoder();
    }

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
	    User user = userRepository.findByUsername(username);

	    if (user != null) {
	        UserBuilder builder = org.springframework.security.core.userdetails.User.withUsername(user.getUsername());
	        builder.username(user.getUsername());
	        builder.password(user.getPassword());
	        builder.authorities(new SimpleGrantedAuthority(user.getRole()));

	        return builder.build();
	    } else {
	        throw new UsernameNotFoundException("User no encontrado con el email: " + username);
	    }
	}



	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	public com.example.demo.entity.User registrar(com.example.demo.entity.User user){
		
		user.setPassword(passwordEncoder().encode(user.getPassword()));		
		user.setRole("ROLE_USER");
		user.setUsername(user.getUsername());
		user.setName(user.getName());
		return userRepository.save(user);
	}
	
	public com.example.demo.entity.User adminregistrar(com.example.demo.entity.User user){
		
		user.setPassword(passwordEncoder().encode(user.getPassword()));		
		user.setRole(user.getRole());
		user.setUsername(user.getUsername());
		user.setName(user.getName());
		return userRepository.save(user);
	}


	@Override
	public List<UserModel> listAllUsers() {
		ModelMapper modelMapper = new ModelMapper();
		List<User> usersList = userRepository.findAll();
		return usersList.stream().map(user -> modelMapper.map(user, UserModel.class))
				.collect(Collectors.toList());
	}

	
	@Override
	public User addUser(UserModel alumnoModel) {
		User nuevoUser = new User();
		nuevoUser.setName(alumnoModel.getName());
//        nuevoAlumno.setUsername(alumnoModel.getUsername());
		nuevoUser.setPassword(alumnoModel.getPassword());
//        nuevoAlumno.setIdFamilia(alumnoModel.getIdFamilia());

		return userRepository.save(nuevoUser);
	}

	public int removeUser(int id) {
		userRepository.deleteById(id);
		return id;
	}

	@Override
	public User updateUser(UserModel userModel) {
		User userExistente = userRepository.findById(userModel.getIduser());
		if (userExistente != null) {
			userExistente.setName(userModel.getName());
			userExistente.setUsername(userModel.getUsername());
			userExistente.setEmail(userModel.getEmail());
			if(!userModel.getPassword().equals("")) {
				userExistente.setPassword(passwordEncoder().encode(userModel.getPassword()));
			}
			

			return userRepository.save(userExistente);
		}
		return userExistente;
	}

	@Override
	public User loadUserById(int id) {
		User user = userRepository.findById(id);
		return user;
	}
	
	public String getCurrentUsername() {
	    Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	    if (principal instanceof UserDetails) {
	        return ((UserDetails) principal).getUsername();
	    } else if (principal instanceof String) {
	        return (String) principal;
	    }
	    return "Nombre de usuario desconocido";
	}
	
	
	
	

	public String deleteUser(UserModel userModel) {
		User userExistente = userRepository.findById(userModel.getIduser());
		if (userExistente != null) {
			userRepository.delete(userExistente);
		}
		return "redirect:/adminAlumno/admin";
	}

	@Override
	public User findUserByUsername(String username) {
		User user = userRepository.findByUsername(username);
		return user;
	}



	@Override
	public User transformUser(UserModel userModel) {
		// TODO Auto-generated method stub
		return null;
	}



	@Override
	public UserModel transformUserModel(User user) {
		// TODO Auto-generated method stub
		return null;
	}


	@Override
	public boolean existsByUsername(String username) {
		User user=userRepository.findByUsername(username);
		if( user != null) {
			return true;
		}
		return false;
	}



	public boolean exists(int id) {
		User u=userRepository.findById(id);
		if( u != null) {
			return true;
		}
		return false;
	}

	@Override
    public boolean checkPassword(String rawPassword, String encodedPassword) {
        return passwordEncoder.matches(rawPassword, encodedPassword);
    }

	@Override
	public int getCurrentUserTeamId(String username) {
		// TODO Auto-generated method stub
		return 0;
	}





	

	

	

	

	
}
