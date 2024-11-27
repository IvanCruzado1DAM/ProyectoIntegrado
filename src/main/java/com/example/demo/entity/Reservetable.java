package com.example.demo.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
public class Reservetable {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int idtable;
	private int idclient;
    private LocalDateTime reservationhour;
	private boolean occupy;
	private boolean wanttopay;

}
