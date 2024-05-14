package com.example.demo.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
public class Multimedia {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id_multimedia;
	@Column
	private String title_new;
	private String description_new;
	private String image;
	private String title_video;
	private String video;
	private int idteammultimedia;

}
