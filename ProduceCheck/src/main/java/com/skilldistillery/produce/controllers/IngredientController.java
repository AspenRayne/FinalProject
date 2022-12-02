package com.skilldistillery.produce.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.skilldistillery.produce.entities.Ingredient;
import com.skilldistillery.produce.services.api.KrogerAPIService;

@RestController
@RequestMapping("api")
@CrossOrigin({ "*", "http://localhost/" })
public class IngredientController {
	
	@Autowired
	private KrogerAPIService krogerService;
	
	@GetMapping("krogerApi")
	public List<Ingredient> searchIngredients(){
		String accessKey = krogerService.getClientAuthorization();
		
		return null; 
	}

}
