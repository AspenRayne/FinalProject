package com.skilldistillery.produce.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.skilldistillery.produce.entities.Comment;
import com.skilldistillery.produce.repositories.CommentRepository;
import com.skilldistillery.produce.repositories.RecipeRepository;

@Service
public class CommentServiceImpl implements CommentService {

	@Autowired
	private CommentRepository commentRepo;

	@Autowired
	private RecipeRepository recipeRepo;

	@Override
	public List<Comment> findByRecipeId(int recipeId) {
		if (!recipeRepo.existsById(recipeId)) {
			return null;
		}
		return commentRepo.findByRecipeId(recipeId);
	}

}
