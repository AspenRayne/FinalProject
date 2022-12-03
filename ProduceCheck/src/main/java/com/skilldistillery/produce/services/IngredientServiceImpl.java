package com.skilldistillery.produce.services;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.skilldistillery.produce.entities.Category;
import com.skilldistillery.produce.entities.Ingredient;
import com.skilldistillery.produce.repositories.CategoryRepository;
import com.skilldistillery.produce.repositories.IngredientRepository;

@Service
public class IngredientServiceImpl implements IngredientService {

	@Autowired
	IngredientRepository ingredientRepo;

	@Autowired
	CategoryRepository categoryRepo;

	@Override
	public Ingredient create(Ingredient ingredient) {
		ingredient = ingredientRepo.saveAndFlush(ingredient);
		List<Category> categories = ingredient.getCategories();
		if (categories != null) {
			for (Category category : categories) {
				categoryRepo.save(category);
			}
		}
		return ingredient;
	}

	@Override
	public List<Ingredient> categoryUnificationProcessor(List<Ingredient> ingredients) {

		/*
		 * ---- Persistence Layer Storage Checks---- SKIPS INGREDIENTS THAT ALREADY
		 * EXIST Prevent unnecessary database transactions. Move All categories on
		 * ingredient list into a set check and pull from database existing categories
		 * to preserve uniqueness
		 */
		List<Category> categoryList = categoryRepo.findAll();
		Map<String, Category> categoryMap = new HashMap<>();
		for (Category category : categoryList) {
			categoryMap.put(category.getName(), category);
		}
		
		// Add new categories onto map
		for (Ingredient ingredient : ingredients) {

			List<Category> categories = ingredient.getCategories();
			if (categories != null) {
				for (Category category : categories) {
					// if category name is in the set
					if (categoryMap.get(category.getName()) != null) {
						continue;
					}
					categoryMap.put(category.getName(), category);
				}
			}
		}

		// add the database inclusive list of categories back onto the ingredients
		// many kroger api ingredients duplicate their category. use a name set to
		// prevent duplicate many to many

		for (Ingredient ingredient : ingredients) {
			// Check if ingredient exists in db
			Ingredient dbIngredient = ingredientRepo.findByUpc(ingredient.getUpc());
			if (dbIngredient != null) {
				continue;
			}
			
			List<Category> categories = ingredient.getCategories();
			Set<String> categoryNames = new HashSet<>();
			for (Category category : categories) {
				categoryNames.add(category.getName());
			}
			
			ingredient.setCategories(null);
			for (String name : categoryNames) {
				Category category = categoryMap.get(name);
				if (category != null) {
					ingredient.addCategory(category);
					category.addIngredient(ingredient);
				}
			}

		}

		return ingredients;
	}

}
