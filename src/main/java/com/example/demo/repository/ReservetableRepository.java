package com.example.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.entity.Reservetable;

@Repository("reservetableRepository")
public interface ReservetableRepository extends JpaRepository <Reservetable, Integer> {
	public abstract Reservetable findByIdtable(int id);
	public abstract Reservetable findByIdclient(int id);
	public abstract List<Reservetable> findByNumtable(int numtable);
	public abstract List<Reservetable> findListByIdclient(int idClient);
}
