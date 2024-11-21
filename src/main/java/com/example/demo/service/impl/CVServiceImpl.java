package com.example.demo.service.impl;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.example.demo.entity.Cv;
import com.example.demo.entity.User;
import com.example.demo.model.CvModel;
import com.example.demo.repository.CvRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.CvService;

@Service("cvService")
public class CVServiceImpl implements CvService {

	@Autowired
	@Qualifier("cvRepository")
	private CvRepository cvRepository;
	
	@Autowired
	@Qualifier("userRepository")
	private UserRepository userRepository;

	@Override
	public List<CvModel> listAllCvs() {
		ModelMapper modelMapper = new ModelMapper();
		List<Cv> eventsList = cvRepository.findAll();
		return eventsList.stream().map(user -> modelMapper.map(user, CvModel.class)).collect(Collectors.toList());

	}

	@Override
	public Cv addCv(CvModel cvModel) {
		Cv newCv = new Cv();

		// Asignar campos básicos
		newCv.setIdcv(cvModel.getIdcv());
		newCv.setIdusercv(cvModel.getIdusercv());
		newCv.setAccept(cvModel.isAccept());

		// Asignar el documento PDF si existe
		if (cvModel.getCvdocument() != null) {
			newCv.setCvdocument(cvModel.getCvdocument());
		}

		return cvRepository.save(newCv);
	}

	@Override
	public Cv transformCv(CvModel cvModel) {
		if (cvModel == null) {
			return null;
		}

		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(cvModel, Cv.class);
	}

	@Override
	public CvModel transformCvModel(Cv cv) {
		CvModel cvModel = new CvModel();
		cvModel.setIdcv(cv.getIdcv());
		cvModel.setIdusercv(cv.getIdusercv());
		cvModel.setCvdocument(cv.getCvdocument());
		cvModel.setAccept(cv.isAccept());

		return cvModel;
	}

	@Override
	public Cv loadCvById(int id) {
		Cv cv = cvRepository.findByIdcv(id);
		return cv;
	}

	@Override
	public boolean exists(int id) {
		Cv cv=cvRepository.findByIdcv(id);
		if( cv != null) {
			return true;
		}
		return false;
	}

	@Override
	public byte[] convertCvDocumentToPdf(int id) {
	    // Obtiene el CV por su ID
	    Cv cv = cvRepository.findByIdcv(id);
	    if (cv == null) {
	        throw new IllegalArgumentException("El CV con ID " + id + " no existe.");
	    }

	    // Convierte el documento del CV a un PDF legible
	    return generatePdfFromBytes(cv.getCvdocument());
	}

	private byte[] generatePdfFromBytes(byte[] cvDocumentBytes) {
	    if (cvDocumentBytes == null || cvDocumentBytes.length == 0) {
	        throw new IllegalArgumentException("El documento CV está vacío o no es válido.");
	    }

	    try (ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
	        // Crear un documento PDF nuevo
	        PDDocument document = new PDDocument();
	        PDPage page = new PDPage();
	        document.addPage(page);

	        // Escribir contenido en la página del PDF
	        try (PDPageContentStream contentStream = new PDPageContentStream(document, page)) {
	            contentStream.beginText();
	            contentStream.setFont(PDType1Font.HELVETICA, 12);
	            contentStream.newLineAtOffset(50, 700);

	            // Interpretar los bytes como texto (si el contenido no es texto, necesitarás adaptar esto)
	            String content = new String(cvDocumentBytes, StandardCharsets.UTF_8);
	            contentStream.showText(content);

	            contentStream.endText();
	        }

	        // Guardar el documento en el flujo de salida
	        document.save(outputStream);
	        document.close();

	        return outputStream.toByteArray();
	    } catch (IOException e) {
	        throw new RuntimeException("Error al crear PDF desde bytes: " + e.getMessage(), e);
	    }
	}

	public void acceptCv(int id, CvModel model) {
		 System.out.println("sdhbfjsdbfjbjk");
	    Cv cv = cvRepository.findByIdcv(id);
	    cv.setAccept(true);
	    User user = userRepository.findById(cv.getIdusercv());
	    user.setRole("ROLE_WAITER");

	    cvRepository.save(cv); 
	    userRepository.save(user); 
	}
	
	public ResponseEntity<byte[]> getCvFile(int id) {
        // Recuperar el CV desde la base de datos
        Cv cv = cvRepository.findById(id).orElse(null);
        
        if (cv == null) {
            // Si no se encuentra el CV, retornar un error 404
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        byte[] cvBytes = cv.getCvdocument(); // Obtener el array de bytes del archivo

        // Configurar las cabeceras HTTP para la respuesta
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_PDF); // Si es PDF (puedes cambiar esto según el tipo de archivo)
        headers.setContentDispositionFormData("attachment", "CV_" + id + ".pdf");
        headers.setContentLength(cvBytes.length);

        // Retornar el archivo como un ResponseEntity con las cabeceras configuradas
        return new ResponseEntity<>(cvBytes, headers, HttpStatus.OK);
    }


}
