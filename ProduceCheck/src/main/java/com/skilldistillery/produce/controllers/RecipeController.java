package com.skilldistillery.produce.controllers;

import java.security.Principal;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.skilldistillery.produce.entities.Recipe;
import com.skilldistillery.produce.services.RecipeService;

@RestController
@RequestMapping("api")
@CrossOrigin({ "*", "http://localhost/" })
public class RecipeController {

	@Autowired
	private RecipeService recipeService;

	@GetMapping("allrecipes")
	public List<Recipe> index() {
		return recipeService.index();
	}

	@GetMapping("recipes")
	public Set<Recipe> usersRecipes(Principal principal) {
		return recipeService.usersRecipes(principal.getName());
	}

	@PostMapping("recipes")
	public Recipe create(@RequestBody Recipe recipe, HttpServletRequest req, HttpServletResponse res,
			Principal principal) {
		try {
			recipe = recipeService.create(principal.getName(), recipe);
			res.setStatus(201);
			StringBuffer urlSb = req.getRequestURL();
			urlSb.append("/").append(recipe.getId());
			String url = urlSb.toString();
			res.setHeader("Location", url);
		} catch (Exception e) {
			res.setStatus(400);
			recipe = null;
		}
		return recipe;
	}

}