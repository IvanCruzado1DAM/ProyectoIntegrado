package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Drink;
import com.example.demo.entity.Opinion;
import com.example.demo.model.OpinionModel;
import com.example.demo.repository.OpinionRepository;
import com.example.demo.service.OpinionService;

@Service("opinionService")
public class OpinionServiceImpl implements OpinionService {

	@Autowired
	@Qualifier("opinionRepository")
	private OpinionRepository opinionRepository;
	
	@Override
	public List<OpinionModel> listAllOpinions() {
		ModelMapper modelMapper = new ModelMapper();
		List<Opinion> opinionsList = opinionRepository.findAll();
		return opinionsList.stream().map(user -> modelMapper.map(user, OpinionModel.class)).collect(Collectors.toList());

	}

	@Override
	public Opinion addOpinion(OpinionModel opinionModel) {
		Opinion op =new Opinion();
		op.setIdopinion(opinionModel.getIdopinion());
		op.setIduseropinion(opinionModel.getIduseropinion());
		op.setScore(opinionModel.getScore());
		op.setComment(opinionModel.getComment());
		return opinionRepository.save(op);
	}

	@Override
	public Opinion transformOpinion(OpinionModel opinionModel) {
		if (opinionModel == null) {
			return null;
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(opinionModel, Opinion.class);
	}

	@Override
	public OpinionModel transformOpinionModel(Opinion opinion) {
		OpinionModel op =new OpinionModel();
		op.setIdopinion(opinion.getIdopinion());
		op.setIduseropinion(opinion.getIduseropinion());
		op.setScore(opinion.getScore());
		op.setComment(opinion.getComment());
		
		return op;
	}

	@Override
	public Opinion loadOpinionById(int id) {
		Opinion opinion = opinionRepository.findByIdopinion(id);
		return opinion;
	}
	
	@Override
	public Opinion loadOpinionByIduser(int id) {
		Opinion opinion = opinionRepository.findByIduseropinion(id);
		return opinion;
	}

	@Override
	public boolean exists(int id) {
		Opinion opinion = opinionRepository.findByIdopinion(id);
		if( opinion != null) {
			return true;
		}
		return false;
	}

	@Override
	public Opinion updateOpinion(int id, OpinionModel opinionModel) {
		Opinion opinion = opinionRepository.findByIduseropinion(id);
		if (opinion != null) {
			opinion.setIdopinion(opinionModel.getIdopinion());
			opinion.setIduseropinion(opinionModel.getIduseropinion());
			opinion.setScore(opinionModel.getScore());
			opinion.setComment(opinionModel.getComment());
			return opinionRepository.save(opinion);
		}
		return null;
	}

}
