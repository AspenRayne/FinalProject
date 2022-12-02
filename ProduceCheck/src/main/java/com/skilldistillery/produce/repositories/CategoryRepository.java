package com.skilldistillery.produce.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.skilldistillery.produce.entities.Category;

public interface CategoryRepository extends JpaRepository<Category, Integer> {

	Category findByName(String name);
}
