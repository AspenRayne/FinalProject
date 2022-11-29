package com.skilldistillery.produce.entities;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class RecipeTest {

	private static EntityManagerFactory emf;
	private EntityManager em;
	private Recipe recipe;

	@BeforeAll
	static void setUpBeforeClass() throws Exception {
		emf = Persistence.createEntityManagerFactory("JPAVeggieTells");
	}

	@AfterAll
	static void tearDownAfterClass() throws Exception {
		emf.close();
	}

	@BeforeEach
	void setUp() throws Exception {
		em = emf.createEntityManager();
		recipe = em.find(Recipe.class, 1);
	}

	@AfterEach
	void tearDown() throws Exception {
		em.close();
		recipe = null;
	}

	@Test
	void test_Recipe_entity_mapping() {
		assertNotNull(recipe);
		assertEquals("Duck Raviolis", recipe.getName());
	}

	@Test
	void test_Recipe_MTM_Recipe_association() {
		assertNotNull(recipe);
		assertNotNull(recipe.getUsers());
		assertTrue(recipe.getUsers().size() > 0);
	}

	@Test
	void test_Recipe_OTM_RecipeReaction_association() {
		assertNotNull(recipe);
		assertTrue(recipe.getRecipeReactions().size() > 0);
	}
	
	@Test
	void test_Recipe_OTM_Comment_association() {
		assertNotNull(recipe);
		assertTrue(recipe.getComments().size() > 0);
	}
	@Test
	void test_Recipe_OTM_RecipeIngredient_mapping() {
		assertNotNull(recipe);
		assertTrue(recipe.getRecipeIngredients().size() > 0);
	}
	@Test
	void test_Recipe_MTO_User_association() {
		assertNotNull(recipe);
		assertEquals("jdoe",recipe.getUser().getUsername());
	}
}
