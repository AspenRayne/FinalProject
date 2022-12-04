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
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;

import org.hibernate.annotations.CreationTimestamp;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

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

	@JsonIgnore
	@ManyToMany(mappedBy = "recipes")
	private List<User> users;

	@JsonIgnoreProperties({"recipe", "user"})
	@OneToMany(mappedBy = "recipe")
	private List<RecipeReaction> recipeReactions;

	@JsonIgnore
	@OneToMany(mappedBy = "recipe")
	private List<Comment> comments;
	
	@JsonIgnoreProperties({"recipe"})
	@OneToMany(mappedBy="recipe")
	private List<RecipeIngredient> recipeIngredients;
	
	
	@ManyToOne
	@JoinColumn(name="user_id")
	private User user;
	
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
		if (users == null) {
			users = new ArrayList<>();
		}
		if (!users.contains(user)) {
			users.add(user);
			user.addRecipe(this);
		}
	}

	public void removeUser(User user) {
		if (users != null && users.contains(user)) {
			users.remove(user);
			user.removeRecipe(this);
		}
	}

	public List<RecipeReaction> getRecipeReactions() {
		return recipeReactions;
	}

	public void setRecipeReactions(List<RecipeReaction> recipeReactions) {
		this.recipeReactions = recipeReactions;
	}

	public List<Comment> getComments() {
		return comments;
	}

	public void setComments(List<Comment> comments) {
		this.comments = comments;
	}

	public void addComment(Comment comment) {
		if (comments == null) {
			comments = new ArrayList<>();
		}
		if (!comments.contains(comment)) {
			comments.add(comment);
			if (comment.getRecipe() != null) {
				comment.getRecipe().getComments().remove(comment);
			}
			comment.setRecipe(this);
		}
	}

	public void removeComment(Comment comment) {
		if (comments != null) {
			comments.remove(comment);
			comment.setRecipe(null);
		}
	}

	
	public List<RecipeIngredient> getRecipeIngredients() {
		return recipeIngredients;
	}

	public void setRecipeIngredients(List<RecipeIngredient> recipeIngredients) {
		this.recipeIngredients = recipeIngredients;
	}
	
	public void addRecipeIngredient(RecipeIngredient ingredient) {
		if (recipeIngredients == null) {
			recipeIngredients = new ArrayList<>();
		}
		if (!recipeIngredients.contains(ingredient)) {
			recipeIngredients.add(ingredient);
			if (ingredient.getRecipe() != null) {
				ingredient.getRecipe().getRecipeIngredients().remove(ingredient);
			}
			ingredient.setRecipe(this);
		}
	}

	public void removeRecipeIngredient(RecipeIngredient ingredient) {
		if (recipeIngredients != null) {
			recipeIngredients.remove(ingredient);
			ingredient.setRecipe(null);
		}
	}
	
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
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
