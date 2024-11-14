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
public class Event {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int idevent;
	private String eventname, eventdescription;
	private LocalDateTime eventenddate;
	@Lob
    @Column(name = "eventimage", columnDefinition = "MEDIUMBLOB")
    private byte[] eventimage;
} 
