package com.example.demo.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
public class Cv {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int idcv;
	private int idusercv;
	private String username;
	@Lob
    @Column(name = "cvdocument", columnDefinition = "MEDIUMBLOB")
    private byte[] cvdocument;
	private boolean accept;
	
} 
