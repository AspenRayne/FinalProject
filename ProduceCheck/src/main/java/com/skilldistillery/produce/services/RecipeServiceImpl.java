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
		return null;
	}

}
