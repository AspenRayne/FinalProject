package com.skilldistillery.produce.services;

import java.util.List;

import com.skilldistillery.produce.entities.User;

public interface UserService {

	List<User> listAllUsers();
	User show(int id);
//	User create(User user);
	User update(String username, int id, User user);
	boolean delete(String username, int id);
}
