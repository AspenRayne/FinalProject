package com.skilldistillery.produce.entities;

import java.time.LocalDateTime;
import java.util.Objects;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MapsId;
import javax.persistence.Table;

@Table(name = "recipe_reaction")
@Entity
public class RecipeReaction {

	@EmbeddedId
	private RecipeReactionId id;

	@ManyToOne
	@JoinColumn(name = "recipe_id")
	@MapsId(value = "recipeId")
	private Recipe recipe;

	@ManyToOne
	@JoinColumn(name = "user_id")
	@MapsId(value = "userId")
	private User user;

	@Column(name = "reaction_date")
	private LocalDateTime reactionDate;

	public RecipeReaction() {
		super();
	}

	public RecipeReactionId getId() {
		return id;
	}

	public void setId(RecipeReactionId id) {
		this.id = id;
	}

	public Recipe getRecipe() {
		return recipe;
	}

	public void setRecipe(Recipe recipe) {
		this.recipe = recipe;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public LocalDateTime getReactionDate() {
		return reactionDate;
	}

	public void setReactionDate(LocalDateTime reactionDate) {
		this.reactionDate = reactionDate;
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
		RecipeReaction other = (RecipeReaction) obj;
		return Objects.equals(id, other.id);
	}

	@Override
	public String toString() {
		return "RecipeReaction [id=" + id + ", reactionDate=" + reactionDate + "]";
	}

}
