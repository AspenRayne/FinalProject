package com.skilldistillery.produce.entities;

import java.time.LocalDateTime;
import java.util.Objects;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

@Table(name = "recipe_reaction")
@Entity
public class RecipeReaction {

	@EmbeddedId
	private RecipeReactionId id;

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
