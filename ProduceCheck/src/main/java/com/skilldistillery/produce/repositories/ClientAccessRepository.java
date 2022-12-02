package com.skilldistillery.produce.repositories;


import org.springframework.data.jpa.repository.JpaRepository;

import com.skilldistillery.produce.entities.ClientAccess;

public interface ClientAccessRepository extends JpaRepository<ClientAccess, Integer> {
	ClientAccess findFirstByOrderByExpirationDesc();
}
