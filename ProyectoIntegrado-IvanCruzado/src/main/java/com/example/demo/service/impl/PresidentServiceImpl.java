package com.example.demo.service.impl;

import java.io.File;
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
import com.example.demo.entity.Team;
import com.example.demo.model.CoachModel;
import com.example.demo.model.PresidentModel;
import com.example.demo.model.TeamModel;
import com.example.demo.repository.PresidentRepository;
import com.example.demo.repository.TeamRepository;
import com.example.demo.service.PresidentService;

@Service("presidentService")
public class PresidentServiceImpl implements PresidentService{

	@Autowired
	@Qualifier("presidentRepository")
	private PresidentRepository presidentRepository;
	
	@Autowired
	@Qualifier("teamRepository")
	private TeamRepository teamRepository;
	
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
		if(presidentRepository.findById(id).getIdteampresident()!=teamRepository.findByName("Agentes Libres").getId_team()) {
			Team t = teamRepository.findByIdPresident(id);
			t.setIdPresident(presidentRepository.findByName("Null").getId_president());
			teamRepository.save(t);
		}
		String presiFileName = presidentRepository.findById(id).getImage();
	    // Borra el archivo de la imagen del escudo del sistema de archivos
	    if (presiFileName != null && !presiFileName.isEmpty()) {
	        String filePath = "src/main/resources/static" + presiFileName;
	        File file = new File(filePath);
	        if (file.exists()) {
	            file.delete();
	        }
	    }
	    presidentRepository.deleteById(id);
		return id;
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

	public void guardarImagen(President presi, String direfichero, MultipartFile multimediaFile, RedirectAttributes flash) throws IOException {
		Path directory = Paths.get(direfichero);
        if (!Files.exists(directory)) {
            Files.createDirectories(directory);
        }
		if (multimediaFile != null && !multimediaFile.isEmpty()) {
	        // Guarda el archivo en el directorio especificado
	        Path rutalogo = Paths.get(direfichero + multimediaFile.getOriginalFilename());
	        try {
	            Files.write(rutalogo, multimediaFile.getBytes());
	            presi.setImage("/imgs/presidents/" + multimediaFile.getOriginalFilename());
	        } catch (IOException e) {
	            e.printStackTrace();
	            flash.addFlashAttribute("error", "An error occurred while saving the image. Please try again.");
	        }
	    } else {
	        flash.addFlashAttribute("error", "No image file provided or file is empty.");
	    }
	}
	
	public boolean exists(PresidentModel presi, RedirectAttributes flash) {
		int teamId = presi.getIdteampresident();
	    
	    // Obtiene todos los entrenadores
	    List<PresidentModel> presidents = listAllPresidents();
	    
	    // Recorre la lista de entrenadores para verificar si ya existe un entrenador para el equipo
	    for (PresidentModel president : presidents) {
	        if (teamId != 9 && president.getIdteampresident() == teamId) {
	            flash.addFlashAttribute("error", "Ya existe un presidente para este equipo.");
	            return true;
	        }
	    }
	    
	    return false;
	}

	public int obtenerIdPresidentAgenteLibre() {
		int idAgenteLibre=presidentRepository.findByName("Null").getIdteampresident();
		return idAgenteLibre;
	}
	
	public boolean exists(int id) {
		President p=presidentRepository.findById(id);
		if( p != null) {
			return true;
		}
		return false;
	}

}
