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

class CompanyTest {
	
	private static EntityManagerFactory emf;
	private EntityManager em;
	private Company company;

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
		company = em.find(Company.class, 1);
	}

	@AfterEach
	void tearDown() throws Exception {
		em.close();
		company = null;
	}

	@Test
	void test_Company_entity_mapping() {
		assertNotNull(company);
		assertEquals("King Soopers", company.getName());
	}
	@Test
	void test_company_OTM_store_mapping() {
		assertNotNull(company);
		assertTrue(company.getStores().size() > 0);
	}

}
