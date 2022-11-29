package com.skilldistillery.produce.services;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.skilldistillery.produce.entities.Comment;
import com.skilldistillery.produce.entities.Recipe;
import com.skilldistillery.produce.entities.User;
import com.skilldistillery.produce.repositories.CommentRepository;
import com.skilldistillery.produce.repositories.RecipeRepository;
import com.skilldistillery.produce.repositories.UserRepository;

@Service
public class CommentServiceImpl implements CommentService {

	@Autowired
	private CommentRepository commentRepo;

	@Autowired
	private RecipeRepository recipeRepo;
	
	@Autowired
	private UserRepository userRepo;

	@Override
	public List<Comment> findByRecipeId(int recipeId) {
		if (!recipeRepo.existsById(recipeId)) {
			return null;
		}
		return commentRepo.findByRecipeId(recipeId);
	}

	@Override
	public Comment create(int recipeId, String username, Comment comment) {
		Recipe recipe = recipeRepo.queryById(recipeId);
		User user = userRepo.findByUsername(username);
		if (recipe == null) {
			return null;
		}
		comment.setCommentDate(LocalDateTime.now());
		comment.setUser(user);
		comment.setRecipe(recipe);
		commentRepo.saveAndFlush(comment);
		return comment;
	}

}
