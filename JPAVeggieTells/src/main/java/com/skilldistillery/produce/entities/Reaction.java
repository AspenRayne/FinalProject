package com.skilldistillery.produce.entities;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;

@Entity
public class Reaction {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	private char emoji;
	
	@OneToMany(mappedBy="reaction")
	private List<RecipeReaction> recipeReactions;
	
	public Reaction() { }

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public char getEmoji() {
		return emoji;
	}

	public void setEmoji(char emoji) {
		this.emoji = emoji;
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
			if (reaction.getReaction() != null) {
				reaction.getReaction().getRecipeReactions().remove(reaction);
			}
			reaction.setReaction(this);
		}
	}

	public void removeRecipeReaction(RecipeReaction reaction) {
		if (recipeReactions != null) {
			recipeReactions.remove(reaction);
			reaction.setReaction(null);
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
		Reaction other = (Reaction) obj;
		return id == other.id;
	}

	@Override
	public String toString() {
		return "Reaction [id=" + id + ", emoji=" + emoji + "]";
	}
	
	
}
