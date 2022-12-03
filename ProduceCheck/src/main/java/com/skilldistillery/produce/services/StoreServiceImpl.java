package com.skilldistillery.produce.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.skilldistillery.produce.entities.Company;
import com.skilldistillery.produce.entities.Store;
import com.skilldistillery.produce.entities.User;
import com.skilldistillery.produce.repositories.CompanyRepository;
import com.skilldistillery.produce.repositories.StoreRepository;
import com.skilldistillery.produce.repositories.UserRepository;

@Service
public class StoreServiceImpl implements StoreService {
	
	@Autowired
	StoreRepository storeRepo;
	
	@Autowired
	UserRepository userRepo;
	
	@Autowired
	CompanyRepository companyRepo;

	@Override
	public Store setFavoriteStore(String username, Store store) {
		Store storeExist = storeRepo.findByLocationId(store.getLocationId());
		System.out.println(storeExist);
		User user = userRepo.findByUsername(username);
		List<Store> favoriteStores = user.getStores();
		
		for(Store userStore : favoriteStores) {
			if(userStore.getLocationId() == store.getLocationId()) {
				return userStore;
			}
		}
		
		if(storeExist != null) {
			store = storeExist;
		} else {
			store = this.createStore(store);
		}
		user.addStore(store);
		store.addUser(user);
		userRepo.saveAndFlush(user);
		
		return storeRepo.saveAndFlush(store);
	}

	@Override
	public Store createStore(Store store) {
		Company company = store.getCompany();
		Company companyExist = companyRepo.findByName(company.getName());
		if (companyExist != null) {
			company = companyExist;
		} else {
			company = companyRepo.saveAndFlush(company);
		}
		store.setCompany(company);
		
		return storeRepo.saveAndFlush(store);
	}
	
	

}
