package com.skilldistillery.produce.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.skilldistillery.produce.entities.Recipe;
import com.skilldistillery.produce.services.RecipeService;

@RestController
@RequestMapping("api")
@CrossOrigin({"*", "http://localhost/"})
public class RecipeController {
	
	@Autowired
	private RecipeService recipeService;
	
	@GetMapping("allrecipes")
	public List<Recipe> index() {
		return recipeService.index();
	}
}
