package com.example.demo.service;

import java.util.List;

import com.example.demo.entity.Offer;
import com.example.demo.model.OfferModel;

public interface OfferService {

	public abstract List<OfferModel> listAllOffers();
	
	public abstract Offer addOffer(OfferModel offerModel);

	public abstract Offer transformOffer(OfferModel offerModel);

	public abstract OfferModel transformOfferModel(Offer offer);
	
	public abstract Offer loadOfferById(int id);

	public abstract Offer findOfferBytitle(String title);
	
	boolean exists(int id);

	public abstract List<OfferModel> listAllOffersAfterToday();

	public abstract int removeOffer(int id);

	public abstract Offer updateOffer(int id, OfferModel offerModel);



}
