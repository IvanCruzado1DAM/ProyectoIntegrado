package com.example.demo.service;

import java.io.File;
import java.io.IOException;
import java.util.List;

import com.example.demo.entity.Cv;
import com.example.demo.model.CvModel;

public interface CvService {

	public abstract List<CvModel> listAllCvs();
	
	public abstract Cv addCv(CvModel cvModel);
	
	public abstract Cv transformCv(CvModel cvModel);

	public abstract CvModel transformCvModel(Cv cv);
	
	public abstract Cv loadCvById(int id);
	
	boolean exists(int id);
	
	public abstract byte[] convertPdfToBytes(File file) throws IOException;

}
