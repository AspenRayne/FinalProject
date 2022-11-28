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

class UserTest {

	private static EntityManagerFactory emf;
	private EntityManager em;
	private User user;

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
		user = em.find(User.class, 2);
	}

	@AfterEach
	void tearDown() throws Exception {
		em.close();
		user = null;
	}

	@Test
	void test_User_entity_mapping() {
		assertNotNull(user);
		assertEquals("jdoe", user.getUsername());
		assertEquals("USER", user.getRole());
		assertEquals("I am the first user", user.getAboutMe());
	}

	@Test
	void test_User_MTM_Recipe_association() {
		assertNotNull(user);
		assertNotNull(user.getRecipes());
		assertTrue(user.getRecipes().size() > 0);

	}

	@Test
	void test_User_MTM_RecipeReview_association() {
		assertNotNull(user);
		assertTrue(user.getRecipeReactions().size() > 0);
	}
	
	@Test
	void test_User_OTM_Comment_association() {
		assertNotNull(user);
		assertTrue(user.getComments().size() > 0);
	}

	@Test
	void test_User_MTM_Store_association() {
		assertNotNull(user);
		assertNotNull(user.getStores());
		assertTrue(user.getStores().size() > 0);

	}

}
