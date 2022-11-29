package com.skilldistillery.produce.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.skilldistillery.produce.entities.Recipe;
import com.skilldistillery.produce.repositories.RecipeRepository;

@Service
public class RecipeServiceImpl implements RecipeService {

	@Autowired
	private RecipeRepository recipeRepo;

	@Override
	public List<Recipe> index() {
		return recipeRepo.findAll();
	}

}
