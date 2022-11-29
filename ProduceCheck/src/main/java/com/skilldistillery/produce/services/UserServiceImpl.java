package com.skilldistillery.produce.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
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

	@Override
	public User create(User user) {
		return userRepo.saveAndFlush(user);
	}

	@Override
	public User update(int id, User user) {
		User dbUser = show(id);
		if(dbUser != null) {
			dbUser.setUsername(user.getUsername());
			dbUser.setPassword(user.getPassword());
			dbUser.setEnabled(user.getEnabled());
			dbUser.setRole(user.getRole());
			dbUser.setCreatedDate(user.getCreatedDate());
			dbUser.setLoginTimestamp(user.getLoginTimestamp());
			dbUser.setAboutMe(user.getAboutMe());
			dbUser.setProfilePic(user.getProfilePic());
			dbUser.setFirstName(user.getFirstName());
			dbUser.setLastName(user.getLastName());
			dbUser.setRecipes(user.getRecipes());
			dbUser.setRecipeReactions(user.getRecipeReactions());
			dbUser.setComments(user.getComments());
			dbUser.setStores(user.getStores());
		}
		return userRepo.save(dbUser);
	}

	@Override
	public boolean delete(int id) {
		boolean deleted = false;
		if(userRepo.existsById(id)) {
			userRepo.deleteById(id);
			deleted = true;
		}
		return deleted;
	}

}
