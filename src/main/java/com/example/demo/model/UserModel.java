package com.example.demo.model;


import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserModel {
	private int iduser;
	private String name, username, password, email;
	private String role;
	

}
