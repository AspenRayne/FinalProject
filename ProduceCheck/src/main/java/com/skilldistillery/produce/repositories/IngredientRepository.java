package com.skilldistillery.produce.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.skilldistillery.produce.entities.Ingredient;

public interface IngredientRepository extends JpaRepository<Ingredient, Integer> {
	
	Ingredient findByUpc(String upc);

}
