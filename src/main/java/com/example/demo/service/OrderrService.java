package com.example.demo.service;

import java.util.List;

import com.example.demo.entity.Orderr;
import com.example.demo.model.OrderrModel;

public interface OrderrService {

	public abstract List<OrderrModel> listAllOrders();
	
	public abstract Orderr addOrderr(OrderrModel orderModel);

	public abstract int removeOrder(int id);

	public abstract Orderr transformOrder(OrderrModel orderModel);

	public abstract OrderrModel transformOrderModel(Orderr order);
	
	public abstract Orderr loadOrderById(int id);
	
	boolean exists(int id);


}
