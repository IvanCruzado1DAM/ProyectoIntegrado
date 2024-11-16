package com.example.demo.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.Offer;

@Repository("offerRepository")
public interface OfferRepository extends JpaRepository <Offer, Integer> {
	public abstract Offer findByTitle(String title);
	public abstract Offer findByIdoffer(int id);
	public abstract List<Offer> findByOfferenddateBefore(LocalDateTime currentDate);
	public abstract List<Offer> findByOfferenddateAfter(LocalDateTime currentDate);
}
