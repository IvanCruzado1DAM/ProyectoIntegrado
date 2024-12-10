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
import com.example.demo.entity.Reservetable;
import com.example.demo.model.OrderrModel;
import com.example.demo.model.ReservetableModel;
import com.example.demo.service.impl.OrderrServiceImpl;
import com.example.demo.service.impl.ReservetableServiceImpl;

@RestController
@RequestMapping("/apiwaiter")
public class WaiterControllerAPI {
	
	@Autowired
	@Qualifier("orderrService")
	private OrderrServiceImpl orderrService;
	
	@Autowired
	@Qualifier("reservetableService")
	private ReservetableServiceImpl reservetableService;
	
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
	
	// Order
	@GetMapping("/listtables")
	public ResponseEntity<?> listAllTables() {
		try {
			List<ReservetableModel> tables = reservetableService.listAllTables();
			return ResponseEntity.ok(tables);
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("There is a error with the tables!");
		}
	}
	
	@PostMapping("/payOrderr")
	public ResponseEntity<String> payOrderr(@RequestParam int idorder) {
	    // Validar si la orden existe
	    Orderr order = orderrService.loadOrderById(idorder);
	    if (order == null) {
	        return new ResponseEntity<>("Order not found", HttpStatus.OK);
	    }
	    if(order.isPaid()) {
	    	return new ResponseEntity<>("Order already paid", HttpStatus.OK);
	    }
	    Reservetable table = reservetableService.loadTableByIdTable(order.getIdreservetable());
	    // Marcar la orden como pagada
	    order.setPaid(true);
	    // Si la mesa está marcada como "wanttopay", actualizarla
	    if (table.isWanttopay()) {
	        table.setWanttopay(false);
	    }
	    // Guardar los cambios
	    reservetableService.updateTable(table.getIdtable(), reservetableService.transformTableModel(table));
	    orderrService.updateOrder(idorder, orderrService.transformOrderModel(order));

	    return new ResponseEntity<>("Order paid successfully", HttpStatus.OK);
	}
	
	@PostMapping("/confirmAssist")
	public ResponseEntity<String> confirmAssist(@RequestParam int idreservetable) {
	    // Validar si la orden existe
	    Reservetable table = reservetableService.loadTableByIdTable(idreservetable);
	    if (table == null) {
	        return new ResponseEntity<>("Table not found", HttpStatus.OK);
	    }
	    // Marcar la orden como pagada
	    table.setOccupy(true);
	    // Guardar los cambios
	    reservetableService.updateTable(table.getIdtable(), reservetableService.transformTableModel(table));
	    return new ResponseEntity<>("Confirm assist successfully", HttpStatus.OK);
	}
	
	@PostMapping("/settablefree")
	public ResponseEntity<String> settablefree(@RequestParam int idreservetable) {
	    // Validar si la orden existe
	    Reservetable table = reservetableService.loadTableByIdTable(idreservetable);
	    if (table == null) {
	        return new ResponseEntity<>("Table not found", HttpStatus.OK);
	    }
	    // Marcar la orden como pagada
	    table.setOccupy(false);
	    // Guardar los cambios
	    reservetableService.updateTable(table.getIdtable(), reservetableService.transformTableModel(table));
	    return new ResponseEntity<>("Mark table as free successfully", HttpStatus.OK);
	}

}
