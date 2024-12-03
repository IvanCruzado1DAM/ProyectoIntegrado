package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.Orderr;

@Repository("orderrRepository")
public interface OrderrRepository extends JpaRepository <Orderr, Integer> {
	public abstract Orderr findByIdorder(int id);
	public abstract Orderr findByNumtable(int numtable);
	
}
