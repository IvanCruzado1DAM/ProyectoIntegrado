package com.example.demo.model;


import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserModel {
	private int id_user;
	private String name, username, password;
	private int id_team_user;
	private String role;
	

}
