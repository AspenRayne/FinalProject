package com.skilldistillery.produce.services;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.skilldistillery.produce.entities.Recipe;
import com.skilldistillery.produce.entities.User;
import com.skilldistillery.produce.repositories.RecipeRepository;
import com.skilldistillery.produce.repositories.UserRepository;

@Service
public class RecipeServiceImpl implements RecipeService {

	@Autowired
	private RecipeRepository recipeRepo;

	@Autowired
	private UserRepository userRepo;

	@Override
	public List<Recipe> index() {
		return recipeRepo.findAll();
	}

	@Override
	public Set<Recipe> usersRecipes(String username) {
		return recipeRepo.findByUsers_Username(username);
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
		user.removeRecipe(recipe);
		recipeRepo.deleteById(recipeId);
		return !recipeRepo.existsById(recipeId);
	}

}
