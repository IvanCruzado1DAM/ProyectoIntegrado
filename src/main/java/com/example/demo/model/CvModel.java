package com.example.demo.model;

import com.example.demo.entity.Cv;

import jakarta.persistence.Column;
import jakarta.persistence.Lob;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class CvModel {
	private int idcv;
	private int idusercv;
	private String username;
	private byte[] cvdocument;
	private boolean accept;
}
