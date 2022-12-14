package com.skilldistillery.produce.controllers;

import java.security.Principal;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.skilldistillery.produce.entities.Comment;
import com.skilldistillery.produce.services.CommentService;

@RestController
@RequestMapping("api")
@CrossOrigin({ "*", "http://localhost/" })
public class CommentController {

	@Autowired
	private CommentService commentService;

	@GetMapping("recipes/{id}/comments")
	public List<Comment> findByRecipeId(@PathVariable int id, HttpServletResponse res) {
		List<Comment> comments = commentService.findByRecipeId(id);
		if (comments == null) {
			res.setStatus(404);
		}
		return comments;
	}

	@PostMapping("recipes/{id}/comments")
	public Comment create(@PathVariable int id, @RequestBody Comment comment, HttpServletRequest req,
			HttpServletResponse res, Principal principal) {
		try {
			comment = commentService.create(id, principal.getName(), comment);
			if (comment == null) {
				res.setStatus(404);
			} else {
				res.setStatus(201);
				StringBuffer url = req.getRequestURL();
				url.append("/").append(comment.getId());
				res.setHeader("Location", url.toString());
			}
		} catch (Exception e) {
			res.setStatus(400);
			comment = null;
		}
		return comment;
	}
	@PostMapping("recipes/{id}/comments/{cid}")
	public Comment createReply(@PathVariable int id, @RequestBody Comment comment, @PathVariable int cid, HttpServletRequest req,
			HttpServletResponse res, Principal principal) {
		try {
			comment = commentService.createReply(id, principal.getName(), cid, comment);
			if (comment == null) {
				res.setStatus(404);
			} else {
				res.setStatus(201);
				StringBuffer url = req.getRequestURL();
				url.append("/").append(comment.getId());
				res.setHeader("Location", url.toString());
			}
		} catch (Exception e) {
			res.setStatus(400);
			comment = null;
		}
		return comment;
	}

	@DeleteMapping("recipes/{id}/comments/{cid}")
	public void delete(@PathVariable int id, @PathVariable int cid, HttpServletResponse res, Principal principal) {
		try {
			if (commentService.delete(id, cid, principal.getName())) {
				res.setStatus(204);
			} else {
				res.setStatus(404);
			}
		} catch (Exception e) {
			res.setStatus(400);
		}
	}

}
