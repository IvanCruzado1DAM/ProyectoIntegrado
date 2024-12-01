package com.example.demo.controllerAPI;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
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
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.entity.Opinion;
import com.example.demo.entity.Reservetable;
import com.example.demo.model.CvModel;
import com.example.demo.model.DrinkModel;
import com.example.demo.model.EventModel;
import com.example.demo.model.ReservetableModel;
import com.example.demo.service.impl.CVServiceImpl;
import com.example.demo.service.impl.DrinkServiceImpl;
import com.example.demo.service.impl.EventServiceImpl;
import com.example.demo.service.impl.OpinionServiceImpl;
import com.example.demo.service.impl.ReservetableServiceImpl;

@RestController
@RequestMapping("/apiclient")
public class ClientControllerAPI {

	@Autowired
	@Qualifier("drinkService")
	private DrinkServiceImpl drinkService;
	
	@Autowired
	@Qualifier("eventService")
	private EventServiceImpl eventService;
	
	@Autowired
	@Qualifier("cvService")
	private CVServiceImpl cvService;
	
	@Autowired
	@Qualifier("reservetableService")
	private ReservetableServiceImpl reservetableService;
	
	@Autowired
	@Qualifier("opinionService")
	private OpinionServiceImpl opinionService;

	//Drinks
	@GetMapping("/listdrinks")
	public ResponseEntity<?> listAllDrinks() {
		try {
			List<DrinkModel> drinks = drinkService.listAllDrinks(); 
			return ResponseEntity.ok(drinks); 
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("There is a error with the drinks!");
		}
	}
	
	//Events
	@GetMapping("/listevents")
	public ResponseEntity<?> listAllEvents() {
		try {
			List<EventModel> events = eventService.listAllEventsAfterToday(); 
			return ResponseEntity.ok(events); 
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("There is a error with the events!");
		}
	}
	
	//Reserves
	@GetMapping("/listreserves")
	public ResponseEntity<?> listAllReserves() {
		try {
			List<ReservetableModel> reserves = reservetableService.listAllTables(); 
			return ResponseEntity.ok(reserves); 
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("There is a error with the reserves!");
		}
	}
	
	//Cv
	@PostMapping("/uploadCv")
    public ResponseEntity<String> uploadCv(@RequestParam("cvfile") MultipartFile cvFile,
                                           @RequestParam("idusercv") int userId,
                                           @RequestParam("username") String username,
                                           @RequestParam("accept") boolean accept) {
        try {
            // Convertimos el archivo PDF a bytes
            byte[] cvBytes = cvFile.getBytes();

            // Creamos el objeto CV
            CvModel cv = new CvModel();
            cv.setIdusercv(userId);  // Asigna el ID del usuario
            cv.setUsername(username);
            cv.setCvdocument(cvBytes);  // Asigna los bytes del CV
            cv.setAccept(accept);  // Asigna si el CV ha sido aceptado

            // Llamamos al servicio para guardar el CV
            cvService.addCv(cv);

            return ResponseEntity.status(HttpStatus.OK).body("CV uploaded successfully!");
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error uploading CV: " + e.getMessage());
        }
    }
	
	//Table 
	@PostMapping("/reserveTable")
	public ResponseEntity<String> reserveTable(
	        @RequestParam int numtable,
	        @RequestParam int idclient,
	        @RequestParam String reservationHour) {
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		
		 LocalDateTime reservationTime;
		    try {
		        reservationTime = LocalDateTime.parse(reservationHour, formatter);
		    } catch (DateTimeParseException e) {
		        return new ResponseEntity<>("Invalid date format. Expected format: yyyy-MM-dd HH:mm:ss", HttpStatus.BAD_REQUEST);
		    }

	    // Verificar si la mesa existe
	    if (!reservetableService.exists(numtable)) {
	        return new ResponseEntity<>("Table not found", HttpStatus.NOT_FOUND);
	    }
	    // Verificar si ya hay una reserva para esta mesa y esta hora
	    boolean isReserved = reservetableService.checkIfTableIsReserved(numtable, reservationTime);
	    if (isReserved) {
	        return new ResponseEntity<>("This table is already reserved at this time", HttpStatus.CONFLICT);
	    }


	    // Cargar la mesa existente por ID
	    Reservetable existingTable = new Reservetable();


	    // Actualizar los datos de la mesa
	    existingTable.setNumtable(numtable);
	    existingTable.setIdclient(idclient);
	    existingTable.setReservationhour(reservationTime);
	    existingTable.setOccupy(false);
	    existingTable.setWanttopay(false);

	    // Guardar los cambios
	    reservetableService.addTable(reservetableService.transformTableModel(existingTable));

	    return new ResponseEntity<>("Table reserved successfully", HttpStatus.OK);
	}
	
	//Opinion
	@PostMapping("/saveOpinion")
	public ResponseEntity<String> saveOpinion(
	        @RequestParam int iduseropinion,
	        @RequestParam int score,
	        @RequestParam String comment) {
		
	    if (opinionService.loadOpinionByIduser(iduseropinion) !=null) {
	        return new ResponseEntity<>("Your opinion is already saved", HttpStatus.NOT_FOUND);
	    }
	    
	    Opinion op = new Opinion();
	    op.setIduseropinion(iduseropinion);
	    op.setScore(score);
	    op.setComment(comment);

	    // Guardar los cambios
	    opinionService.addOpinion(opinionService.transformOpinionModel(op));

	    return new ResponseEntity<>("Opinion saved successfully", HttpStatus.OK);
	}
	
	@PostMapping("/updateOpinion")
	public ResponseEntity<String> editOpinion(@RequestParam int iduseropinion, @RequestParam int score,
	        @RequestParam String comment) {
		  
	    Opinion op = opinionService.loadOpinionByIduser(iduseropinion);
	    op.setIduseropinion(iduseropinion);
	    op.setScore(score);
	    op.setComment(comment);

	    // Guardar los cambios
	    opinionService.updateOpinion(iduseropinion, opinionService.transformOpinionModel(op));

	    return new ResponseEntity<>("Opinion updated successfully", HttpStatus.OK);
	}
	

}
