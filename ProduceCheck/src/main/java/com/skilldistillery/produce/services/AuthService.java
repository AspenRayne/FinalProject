package com.skilldistillery.produce.services;

import com.skilldistillery.produce.entities.User;

public interface AuthService {
	
	public User register(User user);
	
	public User getUserByUsername(String username);

}
