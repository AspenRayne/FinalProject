package com.skilldistillery.produce.repositories;


import java.util.Set;

import org.springframework.data.jpa.repository.JpaRepository;

import com.skilldistillery.produce.entities.Recipe;

public interface RecipeRepository extends JpaRepository<Recipe, Integer> {
	
	Set<Recipe> findByUsers_Username(String username);
	
	Recipe queryById(int recipeId);

}