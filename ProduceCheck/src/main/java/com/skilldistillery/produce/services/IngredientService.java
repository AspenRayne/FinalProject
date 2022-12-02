package com.skilldistillery.produce.services;

import java.util.List;

import com.skilldistillery.produce.entities.Ingredient;

public interface IngredientService {
	Ingredient create(Ingredient ingredient);
	List<Ingredient> categoryUnificationProcessor(List<Ingredient> ingredients);
}
