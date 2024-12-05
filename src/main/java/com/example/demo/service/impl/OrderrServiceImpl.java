package com.example.demo.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Orderr;
import com.example.demo.model.OrderrModel;
import com.example.demo.repository.OrderrRepository;
import com.example.demo.service.OrderrService;

@Service("orderrService")
public class OrderrServiceImpl implements OrderrService{
	
	@Autowired
	@Qualifier("orderrRepository")
	private OrderrRepository orderrRepository;

	@Override
	public List<OrderrModel> listAllOrders() {
		ModelMapper modelMapper = new ModelMapper();
		List<Orderr> ordersList = orderrRepository.findAll();
		return ordersList.stream().map(user -> modelMapper.map(user, OrderrModel.class))
				.collect(Collectors.toList());
	}

	@Override
	public Orderr addOrderr(OrderrModel orderModel) {
		Orderr or=new Orderr();
		or.setNumtable(orderModel.getNumtable());
		or.setDrinks(orderModel.getDrinks());
		or.setTotal(orderModel.getTotal());
		or.setPaid(orderModel.isPaid());
		
		return orderrRepository.save(or);
		
	}

	@Override
	public int removeOrder(int id) {
		if (orderrRepository.existsById(id)) {
			orderrRepository.deleteById(id);
			return id;
		}
		return -1;
	}
	
	@Override
	public Orderr updateOrder(int id, OrderrModel orderModel) {
		Orderr order = orderrRepository.findByIdorder(id);
		if (order != null) {
			order.setNumtable(orderModel.getNumtable());
			order.setDrinks(orderModel.getDrinks());
			order.setTotal(orderModel.getTotal());
			order.setPaid(orderModel.isPaid());
			

			return orderrRepository.save(order);
		}
		return null;
	}


	@Override
	public Orderr transformOrder(OrderrModel orderModel) {
		if (orderModel == null) {
			return null;
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(orderModel, Orderr.class);
	}

	@Override
	public OrderrModel transformOrderModel(Orderr order) {
		OrderrModel om = new OrderrModel();
		om.setIdorder(order.getIdorder());
		om.setNumtable(order.getNumtable());
		om.setDrinks(order.getDrinks());
		om.setTotal(order.getTotal());
		om.setPaid(order.isPaid());
		return om;
	}

	@Override
	public Orderr loadOrderById(int id) {
		Orderr or = orderrRepository.findByIdorder(id);
		return or;
	}

	@Override
	public boolean exists(int id) {
		Orderr o=orderrRepository.findByIdorder(id);
		if( o != null) {
			return true;
		}
		return false;
	}

	

}
