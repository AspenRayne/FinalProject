package com.skilldistillery.produce.controllers;

import java.security.Principal;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.skilldistillery.produce.entities.Comment;
import com.skilldistillery.produce.entities.Recipe;
import com.skilldistillery.produce.services.CommentService;
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

}
