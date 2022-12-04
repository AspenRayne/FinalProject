package com.skilldistillery.produce.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.skilldistillery.produce.entities.Store;

public interface StoreRepository extends JpaRepository<Store, Integer> {

	Store findByLocationId(Integer locationId);
	Store queryById(int storeId);
}
