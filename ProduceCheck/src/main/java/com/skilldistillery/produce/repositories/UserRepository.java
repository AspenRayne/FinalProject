package com.skilldistillery.produce.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.skilldistillery.produce.entities.User;

public interface UserRepository extends JpaRepository<User, Integer>{
	
	User findByUsername(String username);
	User searchById(int id);
	

}
