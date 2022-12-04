package com.skilldistillery.produce.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.skilldistillery.produce.entities.Comment;

public interface CommentRepository extends JpaRepository<Comment, Integer> {
	
	List<Comment> findByRecipeId(int recipeId);
	Comment findById(int id);
	Comment findByRecipeIdAndId(int recipeId, int commentId);

}
