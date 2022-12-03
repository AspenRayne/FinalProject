package com.skilldistillery.produce.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.skilldistillery.produce.entities.RecipeIngredient;
import com.skilldistillery.produce.entities.RecipeIngredientId;

public interface RecipeIngredientRepository extends JpaRepository<RecipeIngredient, RecipeIngredientId>{

}
