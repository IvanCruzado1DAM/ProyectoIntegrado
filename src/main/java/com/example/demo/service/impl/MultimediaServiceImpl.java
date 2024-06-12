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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.entity.Coach;
import com.example.demo.entity.Dietist;
import com.example.demo.entity.Multimedia;
import com.example.demo.model.CoachModel;
import com.example.demo.model.MultimediaModel;
import com.example.demo.repository.MultimediaRepository;
import com.example.demo.service.MultimediaService;

@Service("multiService")
public class MultimediaServiceImpl implements MultimediaService {
	@Autowired
	@Qualifier("multiRepository")
	private MultimediaRepository multiRepository;
	
	@Override
	public List<MultimediaModel> listAllMultimedia() {
		ModelMapper modelMapper = new ModelMapper();
		List<Multimedia> multiList = multiRepository.findAll();
		return multiList.stream().map(multi -> modelMapper.map(multi, MultimediaModel.class))
				.collect(Collectors.toList());
	}
	
	@Override
	public List<MultimediaModel> listAllMultimediabyIdTeam(int idTeam) {
		ModelMapper modelMapper = new ModelMapper();
		List<Multimedia> multiList = multiRepository.findAll();
		
		List<MultimediaModel> filtredmultiList =  multiList.stream()
				 .filter(multi -> multi.getIdteammultimedia() == idTeam)
				.map(multi -> modelMapper.map(multi, MultimediaModel.class))
				.collect(Collectors.toList());
		return filtredmultiList;
	}

	@Override
	public Multimedia addMultimedia(MultimediaModel multimediaModel) {
		multimediaModel.setTitle_new(multimediaModel.getTitle_new());
		multimediaModel.setDescription_new(multimediaModel.getDescription_new());
		multimediaModel.setImage(multimediaModel.getImage());
		multimediaModel.setTitle_video(multimediaModel.getTitle_video());
		multimediaModel.setVideo(multimediaModel.getVideo());
		multimediaModel.setId_multimedia(multimediaModel.getId_multimedia());
		Multimedia m = transformMultimedia(multimediaModel);
		return multiRepository.save(m);
	}

	@Override
	public int removeMultimedia(int id) {
		String multimediaFileName = multiRepository.findById(id).getImage();
	    // Borra el archivo de la imagen del escudo del sistema de archivos
	    if (multimediaFileName != null && !multimediaFileName.isEmpty()) {
	        String filePath = "src/main/resources/static" + multimediaFileName;
	        File file = new File(filePath);
	        if (file.exists()) {
	            file.delete();
	        }
	    }
		multiRepository.deleteById(id);
		return id;
	}

	@Override
	public Multimedia updateMultimedia(int id, RedirectAttributes flash, MultipartFile multimediaFile,  MultimediaModel model) {
		Multimedia multi = multiRepository.findById(id);
	    if (multi != null) {
	        
	    	multi.setTitle_new(model.getTitle_new());
	    	multi.setDescription_new(model.getDescription_new());
	    	multi.setTitle_video(model.getTitle_video());
	    	multi.setVideo(model.getVideo());

	        String baseDirectory = "src" + File.separator + "main" + File.separator + "resources" + File.separator + "static";
	        String photosDirectory = File.separator + "imgs" + File.separator + "news" + File.separator;
	        String newPhotoTempPath = model.getImage();

	        if (newPhotoTempPath != null && !newPhotoTempPath.isEmpty()) {
	            File newPhotoTempFile = new File(baseDirectory + photosDirectory + newPhotoTempPath).getAbsoluteFile();

	        
	                String oldPhotoPath = multi.getImage();

	                if (oldPhotoPath != null && !oldPhotoPath.isEmpty() && multimediaFile != null && !multimediaFile.isEmpty() ) {
	                    File oldPhoto = new File(baseDirectory + oldPhotoPath);
	                    if (oldPhoto.exists()) {
	                        oldPhoto.delete();
	                    }
	                }

	             addImageMultimedia(multi,multimediaFile,(baseDirectory+photosDirectory));   
	        }

	        flash.addFlashAttribute("success", "New updated successfully!");
	        return multiRepository.save(multi);
	    }
	    return null;
	}
	
	@Override
	public Multimedia updateMultimediaWithoutFile(int id, RedirectAttributes flash, MultimediaModel model) {
		Multimedia multi = multiRepository.findById(id);
	    if (multi != null) {
	    	multi.setTitle_video(model.getTitle_video());
	    	multi.setVideo(model.getVideo());
	    	flash.addFlashAttribute("success", "New updated successfully!");
	        return multiRepository.save(multi);
	    }    
	    
	    return null;
	}

	@Override
	public Multimedia transformMultimedia(MultimediaModel multimediaModel) {
		if (multimediaModel == null) {
			return null; 
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(multimediaModel, Multimedia.class);
	}

	@Override
	public MultimediaModel transformMultimediaModel(Multimedia multimedia) {
		if (multimedia == null) {
			return null; 
		}
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(multimedia, MultimediaModel.class);
	}

	@Override
	public Multimedia loadMultimediaById(int id) {
		Multimedia multi = multiRepository.findById(id);
		return multi;
	}

	@Override
	public void addImageMultimedia(Multimedia multimedia, MultipartFile multimediaFile, String direfichero) {
		if (multimediaFile != null && !multimediaFile.isEmpty()) {
			// Guarda el archivo en el directorio especificado
			Path rutalogo = Paths.get(direfichero + multimediaFile.getOriginalFilename());
			try {
				Files.write(rutalogo, multimediaFile.getBytes());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			multimedia.setImage("/imgs/news/" + multimediaFile.getOriginalFilename());
		}
		
	}

	public boolean exists(int id) {
		Multimedia m=multiRepository.findById(id);
		if( m != null) {
			return true;
		}
		return false;
	}

}
