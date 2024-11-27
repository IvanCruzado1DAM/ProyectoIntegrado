package com.example.demo.service;

import java.util.List;

import com.example.demo.entity.Event;
import com.example.demo.entity.Reservetable;
import com.example.demo.model.EventModel;
import com.example.demo.model.ReservetableModel;

public interface ReservetableService {

	public abstract List<ReservetableModel> listAllTables();
	
	public abstract Reservetable addTable(ReservetableModel tableModel);

	public abstract Reservetable updateTable(int id, ReservetableModel tableModel);
	
	public abstract Reservetable transformTable(ReservetableModel tableModel);

	public abstract ReservetableModel transformTableModel(Reservetable table);
	
	public abstract Reservetable loadTableByIdTable(int id);
	
	public abstract Reservetable loadTableByIdClient(int id);
	
	boolean exists(int id);
	
}
