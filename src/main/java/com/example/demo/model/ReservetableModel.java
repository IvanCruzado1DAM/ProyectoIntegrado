package com.example.demo.model;

import java.time.LocalDateTime;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ReservetableModel {
	private int idtable;
	private int numtable;
	private int idclient;
    private LocalDateTime reservationhour;
	private boolean occupy;
	private boolean wanttopay;
}
