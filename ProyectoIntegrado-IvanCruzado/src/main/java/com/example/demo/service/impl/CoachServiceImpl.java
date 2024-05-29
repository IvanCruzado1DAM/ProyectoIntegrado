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

import com.example.demo.entity.Coach;
import com.example.demo.entity.President;
import com.example.demo.model.CoachModel;
import com.example.demo.model.TeamModel;
import com.example.demo.repository.CoachRepository;
import com.example.demo.service.CoachService;

@Service("coachService")
public class CoachServiceImpl implements CoachService {

	@Autowired
	@Qualifier("coachRepository")
	private CoachRepository coachRepository;
	
	@Autowired
	@Qualifier("teamService")
	private TeamServiceImpl teamService;
	
	@Override
	public List<CoachModel> listAllCoachs() {
		ModelMapper modelMapper = new ModelMapper();
		List<Coach> coachsList = coachRepository.findAll();
		return coachsList.stream().map(p -> modelMapper.map(p, CoachModel.class))
				.collect(Collectors.toList());
	}

	@Override
	public Coach addCoach(CoachModel coachModel) {
		coachModel.setName(coachModel.getName());
		coachModel.setNacionality(coachModel.getNacionality());
		coachModel.setPhoto(coachModel.getPhoto());
		coachModel.setArrival_season(coachModel.getArrival_season());
		coachModel.setIdteamcoach(coachModel.getIdteamcoach());
		Coach c = transformCoach(coachModel);
		return coachRepository.save(c);
	}

	@Override
	public int removeCoach(int id) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public Coach updateCoach(CoachModel coachModel) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Coach transformCoach(CoachModel coachModel) {
		if (coachModel == null) {
			return null; 
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(coachModel, Coach.class);
	}

	@Override
	public CoachModel transformCoachModel(Coach coach) {
		if (coach == null) {
			return null; 
		}
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(coach, CoachModel.class);
	}

	@Override
	public Coach loadCoachById(int id) {
		Coach coach = coachRepository.findById(id);
		return coach;
	}
	
	@Override
	public Coach findByIdteam_coach(int id) {
		 return coachRepository.findByIdteamcoach(id);
	}

	public void guardarImagen(Coach coach, String direfichero, MultipartFile multimediaFile, RedirectAttributes flash) throws IOException {
		Path directory = Paths.get(direfichero);
        if (!Files.exists(directory)) {
            Files.createDirectories(directory);
        }
		if (multimediaFile != null && !multimediaFile.isEmpty()) {
	        // Guarda el archivo en el directorio especificado
	        Path rutalogo = Paths.get(direfichero + multimediaFile.getOriginalFilename());
	        try {
	            Files.write(rutalogo, multimediaFile.getBytes());
	            coach.setPhoto("/imgs/coachs/" + multimediaFile.getOriginalFilename());
	        } catch (IOException e) {
	            e.printStackTrace();
	            flash.addFlashAttribute("error", "An error occurred while saving the image. Please try again.");
	        }
	    } else {
	        flash.addFlashAttribute("error", "No image file provided or file is empty.");
	    }
		
	}

	public boolean exists(CoachModel c, RedirectAttributes flash) {
		TeamModel team = teamService.findById(c.getIdteamcoach());
		Coach existingCoach = findByIdteam_coach(team.getId_team());
		if (existingCoach != null) {
			flash.addFlashAttribute("error", "Ya existe un entrenador para este equipo.");
			return true;
		}else {
			return false;
		}
	}


}
