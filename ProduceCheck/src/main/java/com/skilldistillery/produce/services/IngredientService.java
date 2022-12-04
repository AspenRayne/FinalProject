package com.skilldistillery.produce.services;

import java.util.List;

import com.skilldistillery.produce.entities.Ingredient;

public interface IngredientService {
	Ingredient create(Ingredient ingredient);
	List<Ingredient> bulkCreate(List<Ingredient> ingredients);
}
