package com.skilldistillery.produce.controllers;

import java.security.Principal;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.skilldistillery.produce.entities.User;
import com.skilldistillery.produce.services.UserService;

@RestController
@RequestMapping("api")
@CrossOrigin({"*", "http://localhost/"})
public class UserController {
	
	@Autowired
	private UserService userServ;
	
	@GetMapping("users")
	public List<User> index(){
		return userServ.listAllUsers();
	}
	
	@GetMapping("users/{id}")
	public User find(@PathVariable int id, HttpServletResponse res) {
		User user = userServ.show(id);
		if(user == null) {
			res.setStatus(404);
		}
		return user;
	}
	
//	@PostMapping("users")
//	public User create(@RequestBody User user, HttpServletResponse res, Principal principal) {
//		User newUser = null;
//		try {
//			newUser = userServ.create(principal.getName(), user);
//			res.setStatus(201);
//		}catch(Exception e) {
//			e.printStackTrace();
//			res.setStatus(400);
//		}
//		return newUser;
//	}
	
	@PutMapping("users/{id}")
	public User update(@PathVariable int id, @RequestBody User user, HttpServletResponse res, Principal principal) {
		User updateUser = null;
		try {
			updateUser = userServ.update(principal.getName(), id,  user);
			res.setStatus(201);
		} catch(Exception e) {
			e.printStackTrace();
			res.setStatus(400);
		}
		return updateUser;
	}
	@DeleteMapping("users/{id}")
	public boolean destroy(@PathVariable int id, HttpServletResponse res, Principal principal) {
		boolean deleted = userServ.delete(principal.getName(), id);
		if(principal != null && deleted) {
				res.setStatus(204);
				return deleted;
			} else {
				res.setStatus(400);
				return false;
			}

		}
			
		
	}

