package com.example.demo.controllerAPI;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.entity.Orderr;
import com.example.demo.model.OrderrModel;
import com.example.demo.service.impl.OrderrServiceImpl;

@RestController
@RequestMapping("/apiwaiter")
public class WaiterControllerAPI {
	
	@Autowired
	@Qualifier("orderrService")
	private OrderrServiceImpl orderrService;
	
	// Order
	@GetMapping("/listorders")
	public ResponseEntity<?> listAllOrderrs() {
		try {
			List<OrderrModel> orders = orderrService.listAllOrders();
			return ResponseEntity.ok(orders);
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("There is a error with the orders!");
		}
	}
	
	@PostMapping("/payOrderr")
	public ResponseEntity<String> payOrderr(@RequestParam int idorder) {

		Orderr order = orderrService.loadOrderById(idorder);
		if(order!=null){
			order.setPaid(true);
			// Guardar los cambios
			orderrService.updateOrder(idorder, orderrService.transformOrderModel(order));

			return new ResponseEntity<>("Order paid successfully", HttpStatus.OK);
		}else {
			return new ResponseEntity<>("Order not found", HttpStatus.OK);
		}
	}
}
