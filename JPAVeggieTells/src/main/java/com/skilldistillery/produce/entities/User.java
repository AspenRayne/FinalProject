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
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;

import org.hibernate.annotations.CreationTimestamp;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Entity
public class User {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;

	private String username;

	private String password;

	private Boolean enabled;

	private String role;
	
	private String email;

	@Column(name = "created_date")
	@CreationTimestamp
	private LocalDateTime createdDate;

	@Column(name = "login_timestamp")
	private LocalDateTime loginTimestamp;

	@Column(name = "about_me")
	private String aboutMe;

	@Column(name = "profile_pic")
	private String profilePic;

	@Column(name = "first_name")
	private String firstName;

	@Column(name = "last_name")
	private String lastName;

	@JsonIgnore
	@ManyToMany
	@JoinTable(name = "favorite_recipe", joinColumns = @JoinColumn(name = "user_id"), inverseJoinColumns = @JoinColumn(name = "recipe_id"))
	private List<Recipe> recipes;

	@JsonIgnore
	@OneToMany(mappedBy = "user")
	private List<RecipeReaction> recipeReactions;

	@JsonIgnore
	@OneToMany(mappedBy = "user")
	private List<Comment> comments;
	
	@JsonIgnoreProperties({"users"})
	@ManyToMany
	@JoinTable(name="user_favorite_store", joinColumns = @JoinColumn(name = "user_id"), inverseJoinColumns = @JoinColumn(name = "store_id"))
	private List<Store> stores;

	@JsonIgnoreProperties({"user"})
	@OneToMany(mappedBy="user")
	private List<Recipe> userRecipes;
	
	public User() {
		super();
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Boolean getEnabled() {
		return enabled;
	}

	public void setEnabled(Boolean enabled) {
		this.enabled = enabled;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public LocalDateTime getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(LocalDateTime createdDate) {
		this.createdDate = createdDate;
	}

	public LocalDateTime getLoginTimestamp() {
		return loginTimestamp;
	}

	public void setLoginTimestamp(LocalDateTime loginTimestamp) {
		this.loginTimestamp = loginTimestamp;
	}

	public String getAboutMe() {
		return aboutMe;
	}

	public void setAboutMe(String aboutMe) {
		this.aboutMe = aboutMe;
	}

	public String getProfilePic() {
		return profilePic;
	}

	public void setProfilePic(String profilePic) {
		this.profilePic = profilePic;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public List<Recipe> getRecipes() {
		return recipes;
	}

	public void setRecipes(List<Recipe> recipes) {
		this.recipes = recipes;
	}

	public void addRecipe(Recipe recipe) {
		if (recipes == null) {
			recipes = new ArrayList<>();
		}
		if (!recipes.contains(recipe)) {
			recipes.add(recipe);
			recipe.addUser(this);
		}
	}

	public void removeRecipe(Recipe recipe) {
		if (recipes != null && recipes.contains(recipe)) {
			recipes.remove(recipe);
			recipe.removeUser(this);
		}
	}

	public List<RecipeReaction> getRecipeReactions() {
		return recipeReactions;
	}

	public void setRecipeReactions(List<RecipeReaction> recipeReactions) {
		this.recipeReactions = recipeReactions;
	}

	public void addRecipeReaction(RecipeReaction reaction) {
		if (recipeReactions == null) {
			recipeReactions = new ArrayList<>();
		}
		if (!recipeReactions.contains(reaction)) {
			recipeReactions.add(reaction);
			if (reaction.getUser() != null) {
				reaction.getUser().getRecipeReactions().remove(reaction);
			}
			reaction.setUser(this);
		}
	}

	public void removeRecipeReaction(RecipeReaction reaction) {
		if (recipeReactions != null) {
			recipeReactions.remove(reaction);
			reaction.setUser(null);
		}
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
			if (comment.getUser() != null) {
				comment.getUser().getComments().remove(comment);
			}
			comment.setUser(this);
		}
	}

	public void removeComment(Comment comment) {
		if (comments != null) {
			comments.remove(comment);
			comment.setUser(null);
		}
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
			store.addUser(this);
		}
	}

	public void removeStore(Store store) {
		if (stores != null && stores.contains(store)) {
			stores.remove(store);
			store.removeUser(this);
		}
	}

	public List<Recipe> getUserRecipes() {
		return userRecipes;
	}

	public void setUserRecipes(List<Recipe> userRecipes) {
		this.userRecipes = userRecipes;
	}

	public void addUserRecipe(Recipe recipe) {
		if (userRecipes == null) {
			userRecipes = new ArrayList<>();
		}
		if (!userRecipes.contains(recipe)) {
			userRecipes.add(recipe);
			if (recipe.getUser() != null) {
				recipe.getUser().getUserRecipes().remove(recipe);
			}
			recipe.setUser(this);
		}
	}

	public void removeUserRecipe(Recipe recipe) {
		if (userRecipes != null) {
			userRecipes.remove(recipe);
			recipe.setUser(null);
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
		User other = (User) obj;
		return id == other.id;
	}

	@Override
	public String toString() {
		return "User [id=" + id + ", username=" + username + ", password=" + password + ", enabled=" + enabled
				+ ", role=" + role + ", email=" + email + ", createdDate=" + createdDate + ", loginTimestamp="
				+ loginTimestamp + ", aboutMe=" + aboutMe + ", profilePic=" + profilePic + ", firstName=" + firstName
				+ ", lastName=" + lastName + "]";
	}

}
