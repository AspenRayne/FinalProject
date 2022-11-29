package com.skilldistillery.produce.services;

import java.util.List;
import java.util.Set;

import com.skilldistillery.produce.entities.Recipe;

public interface RecipeService {
	
	public List<Recipe> index();
	
	public Set<Recipe> usersRecipes(String username);
	
	public Recipe create(String username, Recipe recipe);
	
	public Recipe update(String username, int recipeId, Recipe recipe);

}
