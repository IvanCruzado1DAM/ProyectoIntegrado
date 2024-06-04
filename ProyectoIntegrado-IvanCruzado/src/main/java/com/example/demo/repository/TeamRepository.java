package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.Team;
import com.example.demo.entity.User;

@Repository("teamRepository")
public interface TeamRepository extends JpaRepository <Team, Integer> {
	public abstract Team findByName(String name);
	
	public abstract Team findById(int id);
	
}
