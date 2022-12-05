package com.skilldistillery.produce.controllers;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
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
	
	@GetMapping("ingredientsLookup/{lookup}/{pagination}/{locationId}")
	public JSONObject searchIngredients(
			@PathVariable String lookup, 
			@PathVariable int pagination, 
			@PathVariable int locationId,
			HttpServletResponse res){
		/* 
		 * lookup = search term
		 * pagination = starts at 1. Add 49 for each page.
		 * locationId = 0 for entire catalog. If not 0, apiData will return results 
		 *  that are available in chosen store.
		 * */
		// pagination starts at 1
		JSONObject response = krogerService.ingredientsLookup(lookup, pagination, true, locationId);
		if (response == null) {
			res.setStatus(404);
		}
		return response;
		
	}
	
	@SuppressWarnings("unchecked")
	@PostMapping("availabilityLookup/{storeId}")
	public List<JSONObject> availabilityLookup(@PathVariable int storeId,
			@RequestBody JSONObject data,
			HttpServletResponse res) {
		List<JSONObject> stats = null;
		// Unpack data request
		try {
			List<String> upcList = (ArrayList) data.get("data");
			// Process data
			stats = krogerService.availabilityCheck(storeId, upcList);
			if (stats == null) {
				res.setStatus(500);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			res.setStatus(400);
			return null;
		}
		
		return stats;
	}
	
//	@GetMapping("seedDatabasePlu")
//	public void seedDatabasePlu(){
//		csvService.readCsv();
//	}

}
