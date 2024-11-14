package com.example.demo.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.Cv;
import com.example.demo.entity.Event;

@Repository("cvRepository")
public interface CvRepository extends JpaRepository <Cv, Integer> {
	public abstract Cv findByIdcv(int id);
	
	
}
