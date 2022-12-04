package com.skilldistillery.produce.services;

import java.time.LocalDateTime;
import java.util.ArrayList;
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
	
	@Override
	public Comment createReply(int recipeId, String username, int commentId, Comment replyComment) {
		Recipe recipe = recipeRepo.queryById(recipeId);
		User user = userRepo.findByUsername(username);
		Comment originalComment = commentRepo.findById(commentId);
		if (originalComment == null) {
			return null;
		}
		
		if (recipe == null) {
			return null;
		}
		replyComment.setCommentDate(LocalDateTime.now());
		replyComment.setUser(user);
		replyComment.setRecipe(recipe);
		originalComment.addComment(replyComment);
		System.out.println(originalComment.getComments());
		commentRepo.save(originalComment);
		commentRepo.saveAndFlush(replyComment);
		return replyComment;
	}


	@Override
	public boolean delete(int recipeId, int commentId, String username) {
		boolean deleted = false;
		User user = userRepo.findByUsername(username);
		Comment comment = commentRepo.findByRecipeIdAndId(recipeId, commentId);
		if(comment != null ) {
			user.removeComment(comment);
			commentRepo.delete(comment);
			deleted = true;
		}
		return deleted;
	}

}
