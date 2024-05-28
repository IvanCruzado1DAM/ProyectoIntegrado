package com.example.demo.service.impl;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.entity.President;
import com.example.demo.model.PresidentModel;
import com.example.demo.model.TeamModel;
import com.example.demo.repository.PresidentRepository;
import com.example.demo.service.PresidentService;

@Service("presidentService")
public class PresidentServiceImpl implements PresidentService{

	@Autowired
	@Qualifier("presidentRepository")
	private PresidentRepository presidentRepository;
	
	@Autowired
	@Qualifier("teamService")
	private TeamServiceImpl teamService;
	
	@Override
	public List<PresidentModel> listAllPresidents() {
		ModelMapper modelMapper = new ModelMapper();
		List<President> presidentsList = presidentRepository.findAll();
		return presidentsList.stream().map(p -> modelMapper.map(p, PresidentModel.class))
				.collect(Collectors.toList());
	}

	@Override
	public President addPresident(PresidentModel presidentModel) {
		presidentModel.setName(presidentModel.getName());
		presidentModel.setNacionality(presidentModel.getNacionality());
		presidentModel.setImage(presidentModel.getImage());
		presidentModel.setArrival_year(presidentModel.getArrival_year());
		presidentModel.setIdteampresident(presidentModel.getIdteampresident());
		President p = transformPresident(presidentModel);
		return presidentRepository.save(p);
	}

	@Override
	public int removePresident(int id) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public President updatePresident(PresidentModel presidentModel) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public President transformPresident(PresidentModel presidentModel) {
		if (presidentModel == null) {
			return null; 
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(presidentModel, President.class);
	}

	@Override
	public PresidentModel transformPresidentModel(President president) {
		if (president == null) {
			return null; 
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(president, PresidentModel.class);
	}

	@Override
	public President loadPresidentById(int id) {
		President presi = presidentRepository.findById(id);
		return presi;
	}

	@Override
	public President findByIdteam_president(int id) {
		 return presidentRepository.findByIdteampresident(id);
	}

	public boolean guardarImagen(President presi, String direfichero, MultipartFile multimediaFile, RedirectAttributes flash) {
		TeamModel team = teamService.findById(presi.getIdteampresident());
		President existingPresident = findByIdteam_president(team.getId_team());
		if (existingPresident != null) {
			flash.addFlashAttribute("error", "There is already a president for this team.");
			return false;
		}
		// Verifica si se ha subido un archivo de escudo
		if (multimediaFile != null && !multimediaFile.isEmpty()) {
			// Guarda el archivo en el directorio especificado
			Path rutalogo = Paths.get(direfichero + multimediaFile.getOriginalFilename());
			try {
				Files.write(rutalogo, multimediaFile.getBytes());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			presi.setImage("/imgs/presidents/" + multimediaFile.getOriginalFilename());
			return true;
		}
		return false;
		
	}

}
