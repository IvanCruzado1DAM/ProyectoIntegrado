package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.Pool;

@Repository("poolRepository")
public interface PoolRepository extends JpaRepository <Pool, Integer> {
	public abstract Pool findByNumturn(int id);	
	
	public abstract Pool findByIdpool(int id);	
	
}
