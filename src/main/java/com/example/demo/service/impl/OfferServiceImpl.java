package com.example.demo.service.impl;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Event;
import com.example.demo.entity.Offer;
import com.example.demo.model.OfferModel;
import com.example.demo.repository.OfferRepository;
import com.example.demo.service.OfferService;

@Service("offerSercice")
public class OfferServiceImpl implements OfferService {
	
	@Autowired
	@Qualifier("offerRepository")
	private OfferRepository offerRepository;
	
	@Override
	public List<OfferModel> listAllOffers() {
		ModelMapper modelMapper = new ModelMapper();
		List<Offer> offersList = offerRepository.findAll();
		return offersList.stream().map(user -> modelMapper.map(user, OfferModel.class)).collect(Collectors.toList());
	}

	@Override
	public Offer addOffer(OfferModel offerModel) {
		Offer newOffer = new Offer();
		newOffer.setTitle(offerModel.getTitle());
		newOffer.setOfferenddate(offerModel.getOfferenddate());
		return offerRepository.save(newOffer);
	}

	@Override
	public Offer transformOffer(OfferModel offerModel) {
		if (offerModel == null) {
			return null;
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(offerModel, Offer.class);
	}

	@Override
	public OfferModel transformOfferModel(Offer offer) {
		OfferModel offerModel = new OfferModel();
		offerModel.setTitle(offer.getTitle());
		offerModel.setOfferenddate(offer.getOfferenddate());

		return offerModel;
	}

	@Override
	public Offer loadOfferById(int id) {
		Offer offer = offerRepository.findByIdoffer(id);
		return offer;
	}

	@Override
	public Offer findOfferBytitle(String title) {
		Offer offer = offerRepository.findByTitle(title);
		return offer;
	}

	@Override
	public boolean exists(int id) {
		Offer offer=offerRepository.findByIdoffer(id);
		if( offer != null) {
			return true;
		}
		return false;
	}

}
