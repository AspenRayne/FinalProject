package com.skilldistillery.produce.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.skilldistillery.produce.entities.User;
import com.skilldistillery.produce.repositories.UserRepository;

@Service
public class UserServiceImpl implements UserService {

	@Autowired
	private UserRepository userRepo;
	
	
	@Override
	public List<User> listAllUsers() {
		return userRepo.findAll();
	}

	@Override
	public User show(int id) {
		return userRepo.searchById(id);
	}

//	@Override
//	public User create(User user) {
//		return userRepo.saveAndFlush(user);
//	}

	@Override
	public User update(String username, int id, User user) {
		User dbUser = userRepo.findByUsername(username);
		if(dbUser != null) {
			
			dbUser.setAboutMe(user.getAboutMe());
			dbUser.setProfilePic(user.getProfilePic());
			dbUser.setFirstName(user.getFirstName());
			dbUser.setLastName(user.getLastName());
//			dbUser.setRecipes(user.getRecipes());
//			dbUser.setRecipeReactions(user.getRecipeReactions());
//			dbUser.setComments(user.getComments());
//			dbUser.setStores(user.getStores());
		}
		return userRepo.save(dbUser);
	}

	@Override
	public boolean delete(String username, int id) {
		boolean success = false;
		User user = userRepo.findByUsername(username);
		if(user!=null && user.getEnabled()) {
			user.setEnabled(false);
			userRepo.save(user);
			success = true;
		}
		return success;
	}

}
