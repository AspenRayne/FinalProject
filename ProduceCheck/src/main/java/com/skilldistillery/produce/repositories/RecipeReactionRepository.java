package com.skilldistillery.produce.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.skilldistillery.produce.entities.RecipeReaction;
import com.skilldistillery.produce.entities.RecipeReactionId;

public interface RecipeReactionRepository extends JpaRepository<RecipeReaction, RecipeReactionId>{

}
