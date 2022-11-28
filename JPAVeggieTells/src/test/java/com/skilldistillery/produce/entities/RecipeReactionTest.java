package com.skilldistillery.produce.entities;

import static org.junit.jupiter.api.Assertions.*;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class RecipeReactionTest {


	private static EntityManagerFactory emf;
	private EntityManager em;
	private RecipeReaction reaction;

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
		RecipeReactionId id = new RecipeReactionId(2,1);
		reaction = em.find(RecipeReaction.class, id);
	}

	@AfterEach
	void tearDown() throws Exception {
		em.close();
		reaction = null;
	}

	@Test
	void test_RecipeReaction_entity_mapping() {
		assertNotNull(reaction);
		assertEquals(2022, reaction.getReactionDate().getYear());
	}
	
	@Test
	void test_RecipeReaction_MTO_reaction_mapping() {
		assertNotNull(reaction);
		assertEquals('X', reaction.getReaction().getEmoji());
	}

}
