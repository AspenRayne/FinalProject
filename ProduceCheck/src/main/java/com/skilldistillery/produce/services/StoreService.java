package com.skilldistillery.produce.services;

import java.util.List;

import com.skilldistillery.produce.entities.Store;

public interface StoreService {
	
	Store setFavoriteStore(String username, Store store);
	Store createStore(Store store);
	boolean unsaveStore(String username, int storeId);
	List<Store> getUserStores(String username);

}
