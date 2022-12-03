package com.skilldistillery.produce.services;

import java.util.List;
import java.util.Set;

import com.skilldistillery.produce.entities.Ingredient;
import com.skilldistillery.produce.entities.Recipe;

public interface RecipeService {

	public List<Recipe> index();

	public Set<Recipe> usersRecipes(String username);

	public Recipe create(String username, Recipe recipe);

	public Recipe update(String username, int recipeId, Recipe recipe);

	public boolean destroy(String username, int recipeId);
	
	public Recipe saveRecipe(String username, int recipeId);
	
	public boolean unsaveRecipe(String username, int recipeId);
	
	public List<Recipe> searchRecipe(String keyword);
	
	public Recipe addIngredient(String username, int recipeId, Ingredient ingredient);

}
