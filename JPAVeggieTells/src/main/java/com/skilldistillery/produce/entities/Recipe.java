package com.skilldistillery.produce.entities;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;

import org.hibernate.annotations.CreationTimestamp;

@Entity
public class Recipe {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;

	private String name;

	private String description;

	@Column(name = "img_url")
	private String imgUrl;

	@Column(name = "creation_date")
	@CreationTimestamp
	private LocalDateTime creationDate;

	private String instructions;

	@Column(name = "prep_time")
	private Integer prepTime;

	@Column(name = "cook_time")
	private Integer cookTime;

	private Boolean published;

	@ManyToMany(mappedBy = "recipes")
	private List<User> users;

	public Recipe() {
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

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getImgUrl() {
		return imgUrl;
	}

	public void setImgUrl(String imgUrl) {
		this.imgUrl = imgUrl;
	}

	public LocalDateTime getCreationDate() {
		return creationDate;
	}

	public void setCreationDate(LocalDateTime creationDate) {
		this.creationDate = creationDate;
	}

	public String getInstructions() {
		return instructions;
	}

	public void setInstructions(String instructions) {
		this.instructions = instructions;
	}

	public Integer getPrepTime() {
		return prepTime;
	}

	public void setPrepTime(Integer prepTime) {
		this.prepTime = prepTime;
	}

	public Integer getCookTime() {
		return cookTime;
	}

	public void setCookTime(Integer cookTime) {
		this.cookTime = cookTime;
	}

	public Boolean getPublished() {
		return published;
	}

	public void setPublished(Boolean published) {
		this.published = published;
	}

	public List<User> getUsers() {
		return users;
	}

	public void setUsers(List<User> users) {
		this.users = users;
	}

	public void addUser(User user) {
		if (users != null) {
			users = new ArrayList<>();
		}
		if (!users.contains(user)) {
			users.add(user);
			user.addRecipe(this);
		}
	}
	
	public void removeUser(User user) {
		if(users != null && users.contains(user)) {
			users.remove(user);
			user.removeRecipe(this);
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
		Recipe other = (Recipe) obj;
		return id == other.id;
	}

	@Override
	public String toString() {
		return "Recipe [id=" + id + ", name=" + name + ", description=" + description + ", imgUrl=" + imgUrl
				+ ", creationDate=" + creationDate + ", instructions=" + instructions + ", prepTime=" + prepTime
				+ ", cookTime=" + cookTime + ", published=" + published + "]";
	}

}
