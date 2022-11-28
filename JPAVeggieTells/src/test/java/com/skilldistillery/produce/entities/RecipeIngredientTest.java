package com.skilldistillery.produce.entities;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class RecipeIngredientTest {


	private static EntityManagerFactory emf;
	private EntityManager em;
	private RecipeIngredient recIng;

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
		RecipeIngredientId id = new RecipeIngredientId(1,1);
		recIng = em.find(RecipeIngredient.class, id);
	}

	@AfterEach
	void tearDown() throws Exception {
		em.close();
		recIng = null;
	}

	@Test
	void test_Comment_entity_mapping() {
		assertNotNull(recIng);
		assertEquals("1/2 cup", recIng.getMeasurement());
	}
	
	@Test
	void test_RecipeIngredient_MTO_recipe_mapping() {
		assertNotNull(recIng);
		assertEquals("Duck Raviolis", recIng.getRecipe().getName());
	}
	
	@Test
	void test_RecipeIngredient_MTO_ingredient_mapping() {
		assertNotNull(recIng);
		assertEquals("Flour", recIng.getIngredient().getName());
	}

}
