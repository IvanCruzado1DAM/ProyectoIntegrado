package com.example.demo.service.impl;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Cv;
import com.example.demo.entity.Opinion;
import com.example.demo.entity.Pool;
import com.example.demo.entity.User;
import com.example.demo.model.CvModel;
import com.example.demo.model.PoolModel;
import com.example.demo.repository.CvRepository;
import com.example.demo.repository.DrinkRepository;
import com.example.demo.repository.PoolRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.CvService;
import com.example.demo.service.PoolService;

@Service("poolService")
public class PoolServiceImpl implements PoolService {
	
	@Autowired
	@Qualifier("poolRepository")
	private PoolRepository poolRepository;
	
	@Override
	public Pool addPool(PoolModel poolModel) {
		Pool p=new Pool();
		p.setNumturn(poolModel.getNumturn());
		return poolRepository.save(p);
	}
	
	@Override
	public Pool updatePool(int id, PoolModel poolModel) {
		Pool p=poolRepository.findByIdpool(id);
		if(p!=null) {
			p.setIdpool(poolModel.getIdpool());
			p.setNumturn(poolModel.getNumturn());
			return poolRepository.save(p);
		}
		return null;
	}

	@Override
	public Pool transformPool(PoolModel poolModel) {
		if (poolModel == null) {
			return null;
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(poolModel, Pool.class);
	}

	@Override
	public PoolModel transformPoolModel(Pool pool) {
		PoolModel pm=new PoolModel();
		pm.setIdpool(pool.getIdpool());
		pm.setNumturn(pool.getNumturn());
		
		return pm;
	}

	


}
