package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.Turnpool;

@Repository("turnpoolRepository")
public interface TurnpoolRepository extends JpaRepository <Turnpool, Integer> {
	public abstract Turnpool findByIdturnpool(int id);	
	
	public abstract List<Turnpool> findByIduserpool(int id);	
	
}
