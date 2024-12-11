package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Orderr;
import com.example.demo.entity.Turnpool;
import com.example.demo.model.OrderrModel;
import com.example.demo.model.TurnpoolModel;
import com.example.demo.repository.TurnpoolRepository;
import com.example.demo.service.TurnpoolService;

@Service("turnpoolService")
public class TurnpoolServiceImpl implements TurnpoolService {
	
	@Autowired
	@Qualifier("turnpoolRepository")
	private TurnpoolRepository turnpoolRepository;
	
	@Override
	public Turnpool addTurnpool(TurnpoolModel turnpoolModel) {
		Turnpool tp=new Turnpool();
		tp.setIduserpool(turnpoolModel.getIduserpool());
		return turnpoolRepository.save(tp);
	}
	
	@Override
	public Turnpool updateTurnpool(int id, TurnpoolModel turnpoolModel) {
		Turnpool tp=turnpoolRepository.findByIdturnpool(id);
		if(tp!=null) {
			tp.setIdturnpool(turnpoolModel.getIdturnpool());
			tp.setIduserpool(turnpoolModel.getIduserpool());
			return turnpoolRepository.save(tp);
		}
		return null;
	}

	@Override
	public Turnpool transformTurnpool(TurnpoolModel turnpoolModel) {
		if (turnpoolModel == null) {
			return null;
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(turnpoolModel, Turnpool.class);
	}

	@Override
	public TurnpoolModel transformTurnpoolModel(Turnpool turnpool) {
		TurnpoolModel tp=new TurnpoolModel();
		tp.setIdturnpool(turnpool.getIdturnpool());
		tp.setIduserpool(turnpool.getIduserpool());
		return tp;
	}

	@Override
	public List<TurnpoolModel> listAllTurnpoolbyuser(int iduserpool) {
		ModelMapper modelMapper = new ModelMapper();
	    // Filtrar directamente desde el repositorio
	    List<Turnpool> list = turnpoolRepository.findByIduserpool(iduserpool);

	    // Mapear la lista de entidades a modelos
	    return list.stream()
	               .map(user -> modelMapper.map(user, TurnpoolModel.class))
	               .collect(Collectors.toList());
	}

	


}
