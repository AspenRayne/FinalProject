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

import com.skilldistillery.produce.entities.Store;
import com.skilldistillery.produce.services.StoreService;
import com.skilldistillery.produce.services.api.KrogerAPIService;

@RestController
@RequestMapping("api")
@CrossOrigin({ "*", "http://localhost/" })
public class StoreController {

	@Autowired
	private KrogerAPIService krogerService;
	
	@Autowired
	private StoreService storeService;

	@GetMapping("stores/{zipcode}")
	public List<Store> getStoreLocations(@PathVariable String zipcode, HttpServletResponse res, HttpServletRequest req,
			Principal principal) {
		List<Store> stores = krogerService.storeLookup(zipcode);
		if (stores == null) {
			res.setStatus(404);
			return null;
		}

		return stores;
	}
	
	@PostMapping("favoriteStore")
	public Store setFavoriteStore(@RequestBody Store store, HttpServletResponse res, HttpServletRequest req,
			Principal principal) {
		
		Store newStore = storeService.setFavoriteStore(principal.getName(), store);
		
		
		return newStore;
	}
	
	@DeleteMapping("favoriteStore/{id}")
	public void unsaveStore(@PathVariable int id, HttpServletResponse res, Principal principal) {
		try {
			if (storeService.unsaveStore(principal.getName(), id)) {
				res.setStatus(204);
			} else {
				res.setStatus(404);
			}
		} catch (Exception e) {
			res.setStatus(400);
		}
		
	}
	
	@GetMapping("favoriteStores")
	public List<Store> getUserStores(HttpServletResponse res, HttpServletRequest req,
			Principal principal){
		List<Store> stores = storeService.getUserStores(principal.getName());
		if (stores == null) {
			res.setStatus(204);
		}
		return stores;
	}
	

}
