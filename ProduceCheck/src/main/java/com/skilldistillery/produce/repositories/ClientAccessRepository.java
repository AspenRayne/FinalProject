package com.skilldistillery.produce.repositories;

import java.sql.Timestamp;

import org.springframework.data.jpa.repository.JpaRepository;

import com.skilldistillery.produce.entities.ClientAccess;

public interface ClientAccessRepository extends JpaRepository<ClientAccess, Integer> {
	ClientAccess findFirstByOrderByExpirationDesc();
}
