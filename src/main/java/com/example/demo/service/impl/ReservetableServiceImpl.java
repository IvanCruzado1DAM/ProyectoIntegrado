package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Reservetable;
import com.example.demo.model.ReservetableModel;
import com.example.demo.repository.ReservetableRepository;
import com.example.demo.service.ReservetableService;

@Service("reservetableService")
public class ReservetableServiceImpl implements ReservetableService{

	@Autowired
	@Qualifier("reservetableRepository")
	private ReservetableRepository reservetableRepository;
	
	@Override
	public List<ReservetableModel> listAllTables() {
		ModelMapper modelMapper = new ModelMapper();
		List<Reservetable> tablesList = reservetableRepository.findAll();
		return tablesList.stream().map(user -> modelMapper.map(user, ReservetableModel.class)).collect(Collectors.toList());
	}

	@Override
	public Reservetable addTable(ReservetableModel tableModel) {
		Reservetable tb=new Reservetable();
		tb.setIdtable(tableModel.getIdtable());
		tb.setIdclient(tableModel.getIdclient());
		tb.setReservationhour(tableModel.getReservationhour());
		tb.setOccupy(tableModel.isOccupy());
		tb.setWanttopay(tableModel.isWanttopay());
		
		return reservetableRepository.save(tb);
	}

	@Override
	public Reservetable transformTable(ReservetableModel tableModel) {
		if (tableModel == null) {
			return null;
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(tableModel, Reservetable.class);
	}

	@Override
	public ReservetableModel transformTableModel(Reservetable table) {
		ReservetableModel tb=new ReservetableModel();
		tb.setIdtable(table.getIdtable());
		tb.setIdclient(table.getIdclient());
		tb.setReservationhour(table.getReservationhour());
		tb.setOccupy(table.isOccupy());
		tb.setWanttopay(table.isWanttopay());
		
		return tb;
	}

	@Override
	public Reservetable loadTableByIdTable(int id) {
		Reservetable tb = reservetableRepository.findByIdtable(id);
		return tb;
	}
	
	@Override
	public Reservetable loadTableByIdClient(int id) {
		Reservetable tb = reservetableRepository.findByIdclient(id);
		return tb;
	}

	@Override
	public boolean exists(int id) {
		Reservetable tb=reservetableRepository.findByIdtable(id);
		if( tb != null) {
			return true;
		}
		return false;
	}

	@Override
	public Reservetable updateTable(int id, ReservetableModel tableModel) {
		Reservetable tb=reservetableRepository.findByIdtable(id);
		if(tb != null) {
			tb.setIdclient(tableModel.getIdclient());
			tb.setReservationhour(tableModel.getReservationhour());
			tb.setOccupy(tableModel.isOccupy());
			tb.setWanttopay(tableModel.isWanttopay());
			
			return reservetableRepository.save(tb);
		}
		return null;
	}

}