package com.example.demo.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Cv;
import com.example.demo.model.CvModel;
import com.example.demo.repository.CvRepository;
import com.example.demo.service.CvService;

@Service("cvService")
public class CVServiceImpl implements CvService {

	@Autowired
	@Qualifier("cvRepository")
	private CvRepository cvRepository;

	@Override
	public List<CvModel> listAllCvs() {
		ModelMapper modelMapper = new ModelMapper();
		List<Cv> eventsList = cvRepository.findAll();
		return eventsList.stream().map(user -> modelMapper.map(user, CvModel.class)).collect(Collectors.toList());

	}

	@Override
	public Cv addCv(CvModel cvModel) {
		Cv newCv = new Cv();

		// Asignar campos básicos
		newCv.setIdcv(cvModel.getIdcv());
		newCv.setIdusercv(cvModel.getIdusercv());
		newCv.setAccept(cvModel.isAccept());

		// Asignar el documento PDF si existe
		if (cvModel.getCvdocument() != null) {
			newCv.setCvdocument(cvModel.getCvdocument());
		}

		return cvRepository.save(newCv);
	}

	@Override
	public Cv transformCv(CvModel cvModel) {
		if (cvModel == null) {
			return null;
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(cvModel, Cv.class);
	}

	@Override
	public CvModel transformCvModel(Cv cv) {
		CvModel cvModel = new CvModel();
		cvModel.setIdcv(cv.getIdcv());
		cvModel.setIdusercv(cv.getIdusercv());
		cvModel.setCvdocument(cv.getCvdocument());
		cvModel.setAccept(cv.isAccept());

		return cvModel;
	}

	@Override
	public Cv loadCvById(int id) {
		Cv cv = cvRepository.findByIdcv(id);
		return cv;
	}

	@Override
	public boolean exists(int id) {
		Cv cv=cvRepository.findByIdcv(id);
		if( cv != null) {
			return true;
		}
		return false;
	}

	@Override
	public byte[] convertPdfToBytes(File file) throws IOException {
		if (file == null || !file.exists()) {
			throw new IllegalArgumentException("El archivo proporcionado es nulo o no existe.");
		}

		try (FileInputStream fis = new FileInputStream(file)) {
			return fis.readAllBytes(); // Lee el contenido del archivo en un arreglo de bytes
		}
	}

}
