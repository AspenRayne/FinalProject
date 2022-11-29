package com.skilldistillery.produce.services;

import java.util.List;

import com.skilldistillery.produce.entities.Comment;

public interface CommentService {
	
	List<Comment> findByRecipeId(int recipeId);
	
	Comment create(int recipeId, String username, Comment comment);
	
	boolean delete(int recipeId, int commentId, String username);
	

}
