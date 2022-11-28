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

class CommentTest {
	
	private static EntityManagerFactory emf;
	private EntityManager em;
	private Comment comment;

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
		comment = em.find(Comment.class, 1);
	}

	@AfterEach
	void tearDown() throws Exception {
		em.close();
		comment = null;
	}

	@Test
	void test_Comment_entity_mapping() {
		assertNotNull(comment);
		assertEquals("I made this for Thanksgiving and it was off the wall!", comment.getComment());
	}
	
	@Test
	void test_Comment_MTO_User_association() {
		assertNotNull(comment);
		assertNotNull(comment.getUser());
		assertEquals("jdoe", comment.getUser().getUsername());
	}
	
	@Test
	void test_Comment_MTO_Recipe_association() {
		assertNotNull(comment);
		assertNotNull(comment.getRecipe());
		assertEquals("Duck Raviolis", comment.getRecipe().getName());
	}
	
	@Test
	void test_comment_MTO_comment() {
		assertNotNull(comment);
		assertNull(comment.getReplyComment());
	}
	
	@Test
	void test_comment_OTM_comment() {
		assertNotNull(comment);
		assertTrue(comment.getComments().size() == 0);
	}
}