package com.skilldistillery.produce.repositories;


import org.springframework.data.jpa.repository.JpaRepository;

import com.skilldistillery.produce.entities.Recipe;

public interface RecipeRepository extends JpaRepository<Recipe, Integer> {

}
