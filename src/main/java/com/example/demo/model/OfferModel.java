package com.example.demo.model;

import java.time.LocalDateTime;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class OfferModel {
	private int idoffer;
	private String title;
	private LocalDateTime offerenddate;
}
