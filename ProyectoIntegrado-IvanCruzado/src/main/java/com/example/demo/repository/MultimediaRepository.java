package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.Multimedia;

@Repository("multiRepository")
public interface MultimediaRepository extends JpaRepository <Multimedia, Integer> {
	public abstract Multimedia findByIdteammultimedia(int id_team_multimedia);
	
	public abstract Multimedia findById(int id);
}
