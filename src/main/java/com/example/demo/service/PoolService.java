package com.example.demo.service;

import com.example.demo.entity.Orderr;
import com.example.demo.entity.Pool;
import com.example.demo.model.PoolModel;

public interface PoolService {
	
	public abstract Pool addPool(PoolModel poolModel);
	
	public abstract Pool updatePool(int id, PoolModel poolModel);
	
	public abstract Pool transformPool(PoolModel poolModel);

	public abstract PoolModel transformPoolModel(Pool pool);
	
	public abstract Pool loadOrderById(int id);
}
