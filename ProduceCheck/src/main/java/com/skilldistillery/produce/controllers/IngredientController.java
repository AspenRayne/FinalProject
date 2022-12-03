package com.skilldistillery.produce.controllers;

import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.skilldistillery.produce.services.PluImportService;
import com.skilldistillery.produce.services.api.KrogerAPIService;

@RestController
@RequestMapping("api")
@CrossOrigin({ "*", "http://localhost/" })
public class IngredientController {
	
	@Autowired
	private KrogerAPIService krogerService;
	
	@Autowired
	private PluImportService csvService;
	
	@GetMapping("ingredientsLookup/{lookup}/{pagination}")
	public JSONObject searchIngredients(
			@PathVariable String lookup, 
			@PathVariable int pagination, 
			HttpServletResponse res){
		// pagination starts at 1
		System.out.println(lookup);
		
		return krogerService.ingredientsLookup(lookup, pagination, true);
		
	}
	
//	@GetMapping("seedDatabasePlu")
//	public void seedDatabasePlu(){
//		csvService.readCsv();
//	}

}
