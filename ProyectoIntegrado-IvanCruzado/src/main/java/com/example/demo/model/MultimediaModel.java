package com.example.demo.model;

import java.sql.Timestamp;

import jakarta.persistence.Column;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class MultimediaModel {

	private int id_multimedia;
	private String title_new;
	private String description_new;
	private String image;
	private String title_video;
	private String video;
	private int idteammultimedia;
}
