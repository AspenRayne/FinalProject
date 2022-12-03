package com.skilldistillery.produce.services;

import com.skilldistillery.produce.entities.Store;

public interface StoreService {
	
	Store setFavoriteStore(String username, Store store);
	Store createStore(Store store);

}
