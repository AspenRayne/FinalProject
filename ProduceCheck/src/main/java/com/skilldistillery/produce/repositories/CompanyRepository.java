package com.skilldistillery.produce.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.skilldistillery.produce.entities.Company;

public interface CompanyRepository extends JpaRepository<Company, Integer> {
	Company findByName(String name);
}
