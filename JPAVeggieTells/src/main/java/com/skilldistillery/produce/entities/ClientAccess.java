package com.skilldistillery.produce.entities;

import java.time.Instant;
import java.util.Objects;
import java.sql.Timestamp;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "client_access")
public class ClientAccess {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;

	private String key;

	private Timestamp expiration;

	public ClientAccess() {

	}

	public void setExpiration() {
		Instant instance = Instant.now().plusSeconds(1790);
		Timestamp timestamp = Timestamp.from(instance);

		this.expiration = timestamp;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public Timestamp getExpiration() {
		return expiration;
	}

	@Override
	public int hashCode() {
		return Objects.hash(id);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		ClientAccess other = (ClientAccess) obj;
		return id == other.id;
	}

	@Override
	public String toString() {
		return "ClientAccess [id=" + id + ", key=" + key + ", expiration=" + expiration + "]";
	}

}
