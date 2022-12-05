package com.skilldistillery.produce.controllers;

import java.security.Principal;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.skilldistillery.produce.entities.Ingredient;
import com.skilldistillery.produce.entities.Reaction;
import com.skilldistillery.produce.entities.Recipe;
import com.skilldistillery.produce.entities.RecipeIngredient;
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

	@GetMapping("recipes/{id}")
	public Recipe show(@PathVariable int id, HttpServletRequest req, HttpServletResponse res, Principal principal) {
		Recipe recipe = new Recipe();
		try {
			recipe = recipeService.show(id);
			if (recipe == null) {
				res.setStatus(404);
			}
		} catch (Exception e) {
			res.setStatus(400);
			recipe = null;
		}
		return recipe;
	}

	@PutMapping("recipes/{id}")
	public Recipe update(@PathVariable int id, @RequestBody Recipe recipe, HttpServletRequest req,
			HttpServletResponse res, Principal principal) {
		try {
			recipe = recipeService.update(principal.getName(), id, recipe);
			if (recipe == null) {
				res.setStatus(404);
			}
		} catch (Exception e) {
			res.setStatus(400);
			recipe = null;
		}
		return recipe;
	}

	@DeleteMapping("recipes/{id}")
	public void destroy(@PathVariable int id, HttpServletRequest req, HttpServletResponse res, Principal principal) {
		try {
			if (recipeService.destroy(principal.getName(), id)) {
				res.setStatus(204);
			} else {
				res.setStatus(404);
			}
		} catch (Exception e) {
			res.setStatus(400);
		}
	}

	@PostMapping("recipes/{id}")
	public Recipe save(@PathVariable int id, HttpServletRequest req, HttpServletResponse res, Principal principal) {
		Recipe recipe = null;
		try {
			recipe = recipeService.saveRecipe(principal.getName(), id);
			if (recipe == null) {
				res.setStatus(404);
			}
		} catch (Exception e) {
			res.setStatus(400);
		}
		return recipe;

	}

	@DeleteMapping("favoritedRecipes/{id}")
	public void unsaveRecipe(@PathVariable int id, HttpServletResponse res, Principal principal) {
		try {
			if (recipeService.unsaveRecipe(principal.getName(), id)) {
				res.setStatus(204);
			} else {
				res.setStatus(404);
			}
		} catch (Exception e) {
			res.setStatus(400);
		}

	}

	@GetMapping("recipes/search/{search}")
	public List<Recipe> recipeSearch(@PathVariable String search) {
		return recipeService.searchRecipe(search);
	}

	@PutMapping("recipes/addIngredient/{id}")
	public Recipe addIngredient(@PathVariable int id, @RequestBody Ingredient ingredient, HttpServletResponse res,
			HttpServletRequest req, Principal principal) {
		Recipe recipe;
		try {
			recipe = recipeService.addIngredient(principal.getName(), id, ingredient);
			if (recipe == null) {
				res.setStatus(404);
			}
		} catch (Exception e) {
			e.printStackTrace();
			res.setStatus(400);
			recipe = null;
		}
		return recipe;

	}

	@PostMapping("recipes/{id}/react")
	public Recipe reactToRecipe(@PathVariable int id, Reaction reaction, HttpServletRequest req,
			HttpServletResponse res, Principal principal) {
		Recipe recipe = null;
		try {
			recipe = recipeService.addReaction(principal.getName(), id, reaction);
			if (recipe == null) {
				res.setStatus(404);
			}
		} catch (Exception e) {
			res.setStatus(400);
		}
		return recipe;

	}

	@DeleteMapping("recipes/removeIngredient/{id}/{ingredientId}")
	public Recipe unsaveIngredient(@PathVariable int id, @PathVariable int ingredientId, HttpServletResponse res,
			HttpServletRequest req, Principal principal) {
		Recipe recipe = recipeService.unsaveIngredient(principal.getName(), id, ingredientId);
		if (recipe == null) {
			res.setStatus(404);
		}
		return recipe;

	}

	@PutMapping("recipes/{recipeId}/{ingredientId}")
	public RecipeIngredient saveMesasurement(@PathVariable int recipeId, @PathVariable int ingredientId,
			HttpServletRequest req, HttpServletResponse res, Principal principal,
			@RequestBody RecipeIngredient recipeIngredient) {
		
		if(recipeIngredient == null) {
			res.setStatus(404);
		}
		
		recipeService.addMeasurement(principal.getName(), recipeId, ingredientId, recipeIngredient);
		
		return recipeIngredient;
	}

}
