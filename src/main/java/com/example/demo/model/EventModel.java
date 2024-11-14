package com.example.demo.model;

import java.time.LocalDateTime;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class EventModel {
	private int idevent;
	private String eventname, eventdescription;
	private LocalDateTime eventenddate;
	private byte[] eventimage;
	private MultipartFile eventImageFile;
	private String imageUrl; 
}
