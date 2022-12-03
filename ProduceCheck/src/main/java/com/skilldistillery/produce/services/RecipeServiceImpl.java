package com.skilldistillery.produce.services;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.skilldistillery.produce.entities.Ingredient;
import com.skilldistillery.produce.entities.Recipe;
import com.skilldistillery.produce.entities.RecipeIngredient;
import com.skilldistillery.produce.entities.User;
import com.skilldistillery.produce.repositories.RecipeRepository;
import com.skilldistillery.produce.repositories.UserRepository;

@Service
public class RecipeServiceImpl implements RecipeService {

	@Autowired
	private RecipeRepository recipeRepo;

	@Autowired
	private UserRepository userRepo;

	@Autowired
	private IngredientService ingredientService;

	@Override
	public List<Recipe> index() {
		return recipeRepo.findAll();
	}

	@Override
	public Set<Recipe> usersRecipes(String username) {
		return recipeRepo.findByUser_Username(username);
	}

	@Override
	public Recipe create(String username, Recipe recipe) {
		User user = userRepo.findByUsername(username);
		if (user != null) {
			recipe.setUser(user);
			return recipeRepo.saveAndFlush(recipe);
		}
		return null;
	}

	@Override
	public Recipe update(String username, int recipeId, Recipe recipe) {
		Recipe managed = recipeRepo.findByUser_UsernameAndId(username, recipeId);
		managed.setName(recipe.getName());
		managed.setDescription(recipe.getDescription());
		managed.setImgUrl(recipe.getImgUrl());
		managed.setInstructions(recipe.getInstructions());
		managed.setPrepTime(recipe.getPrepTime());
		managed.setCookTime(recipe.getCookTime());
		managed.setPublished(recipe.getPublished());

		return recipeRepo.save(managed);

	}

	@Override
	public boolean destroy(String username, int recipeId) {
		User user = userRepo.findByUsername(username);
		Recipe recipe = recipeRepo.findByUser_UsernameAndId(username, recipeId);
		user.removeUserRecipe(recipe);
		recipeRepo.deleteById(recipeId);
		return !recipeRepo.existsById(recipeId);
	}

	@Override
	public Recipe saveRecipe(String username, int recipeId) {
		Recipe recipe = recipeRepo.queryById(recipeId);
		User user = userRepo.findByUsername(username);
		if (recipe != null) {
			user.addRecipe(recipe);
			recipe.addUser(user);
			userRepo.save(user);
			recipeRepo.save(recipe);
			return recipe;
		}
		return null;
	}

	@Override
	public boolean unsaveRecipe(String username, int recipeId) {
		Recipe recipe = recipeRepo.queryById(recipeId);
		User user = userRepo.findByUsername(username);
		if (recipe != null) {
			user.removeRecipe(recipe);
			recipe.removeUser(user);
			userRepo.save(user);
			recipeRepo.save(recipe);
			return true;
		}
		return false;
	}

	@Override
	public List<Recipe> searchRecipe(String keyword) {
		String searchString = '%' + keyword + '%';
		List<Recipe> recipes = recipeRepo.findByNameLike(searchString);
		return recipes;
	}

	@Override
	public Recipe addIngredient(String username, int recipeId, Ingredient ingredient) {
		List<Ingredient> ingredients = new ArrayList<>();
		ingredients.add(ingredient);
		ingredients = ingredientService.bulkCreate(ingredients);
		Ingredient storedIngredient = ingredients.get(0);
		if (storedIngredient == null) {
			return null;
		}
		System.out.println(username);
		System.out.println(recipeId);
		Recipe recipe = recipeRepo.findByUser_UsernameAndId(username, recipeId);
		if (recipe == null) {
			return null;
		}
		
		RecipeIngredient recipeIngredient = new RecipeIngredient();

		recipeIngredient.setRecipe(recipe);
		recipeIngredient.setIngredient(storedIngredient);

		recipe.addRecipeIngredient(recipeIngredient);
		recipe = recipeRepo.saveAndFlush(recipe); 
		return recipe;

	}

}
