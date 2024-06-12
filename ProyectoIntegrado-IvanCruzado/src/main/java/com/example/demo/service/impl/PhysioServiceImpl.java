package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Dietist;
import com.example.demo.entity.Physio;
import com.example.demo.entity.Player;
import com.example.demo.entity.Team;
import com.example.demo.model.PhysioModel;
import com.example.demo.model.PlayerModel;
import com.example.demo.model.TeamModel;
import com.example.demo.repository.PhysioRepository;
import com.example.demo.service.PhysioService;

@Service("physioService")
public class PhysioServiceImpl implements PhysioService {

	@Autowired
	@Qualifier("physioRepository")
	private PhysioRepository physioRepository;
	
	@Override
	public List<PhysioModel> listAllPhysios() {
		ModelMapper modelMapper = new ModelMapper();
		List<Physio> physiosList = physioRepository.findAll();
		return physiosList.stream().map(p -> modelMapper.map(p, PhysioModel.class))
				.collect(Collectors.toList());
	}

	@Override
	public Physio addPhysio(PhysioModel physioModel) {
		physioModel.setName(physioModel.getName());
		physioModel.setAge(physioModel.getAge());
		physioModel.setIdteam_physio(physioModel.getIdteam_physio());
		Physio p = transformPhysio(physioModel);
		return physioRepository.save(p);
	}

	@Override
	public int removePhysio(int id) {
		physioRepository.deleteById(id);
		return id;
	}

	@Override
	public Physio updatePhysio(int id, PhysioModel physioModel) {
		Physio physio = physioRepository.findById(id);
		if (physio != null) {
			physio.setName(physioModel.getName());
			physio.setAge(physioModel.getAge());
			physio.setIdteam_physio(physioModel.getIdteam_physio());

			return physioRepository.save(physio);
		}
		return null;
	}

	@Override
	public Physio transformPhysio(PhysioModel physioModel) {
		if (physioModel == null) {
			return null; 
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(physioModel, Physio.class);
	}

	@Override
	public PhysioModel transformPhysioModel(Physio physio) {
		if (physio == null) {
			return null; 
		}
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(physio, PhysioModel.class);
	}

	@Override
	public Physio loadPhysioById(int id) {
		Physio physio = physioRepository.findById(id);
		return physio;
	}

	@Override
	public List<PhysioModel> listAllPhysiosbyIdTeam(int idTeam) {
		ModelMapper modelMapper = new ModelMapper();
		List<Physio> physiosList = physioRepository.findAll();
		
		List<PhysioModel> filtredphysiosList =  physiosList.stream()
				 .filter(p -> p.getIdteam_physio() == idTeam)
				.map(p -> modelMapper.map(p, PhysioModel.class))
				.collect(Collectors.toList());
		return filtredphysiosList;
	}

	public boolean exists(int id) {
		Physio p=physioRepository.findById(id);
		if( p != null) {
			return true;
		}
		return false;
	}

}
