package com.example.demo.model;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class OpinionModel {
	private int idopinion;
	private int iduseropinion;
	private int score;
	private String comment;
}
