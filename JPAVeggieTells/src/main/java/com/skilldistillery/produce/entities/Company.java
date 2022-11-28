package com.skilldistillery.produce.entities;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;

@Entity
public class Company {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	private String name;
	
	@Column(name = "api_host_url")
	private String apiHostUrl;
	
	@OneToMany(mappedBy="company")
	private List<Store> stores;

	public Company() {
		super();
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getApiHostUrl() {
		return apiHostUrl;
	}

	public void setApiHostUrl(String apiHostUrl) {
		this.apiHostUrl = apiHostUrl;
	}
	
	public List<Store> getStores() {
		return stores;
	}

	public void setStores(List<Store> stores) {
		this.stores = stores;
	}
	public void addStore(Store store) {
		if (stores == null) {
			stores = new ArrayList<>();
		}
		if (!stores.contains(store)) {
			stores.add(store);
			if (store.getCompany() != null) {
				store.getCompany().getStores().remove(store);
			}
			store.setCompany(this);
		}
	}

	public void removeStore(Store store) {
		if (stores != null) {
			stores.remove(store);
			store.setCompany(null);
		}
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
		Company other = (Company) obj;
		return id == other.id;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("Company [id=");
		builder.append(id);
		builder.append(", name=");
		builder.append(name);
		builder.append(", apiHostUrl=");
		builder.append(apiHostUrl);
		builder.append("]");
		return builder.toString();
	}
	
	
}
