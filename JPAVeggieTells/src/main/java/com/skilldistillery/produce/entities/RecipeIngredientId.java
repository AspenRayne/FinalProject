package com.skilldistillery.produce.entities;

import java.io.Serializable;
import java.util.Objects;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class RecipeIngredientId implements Serializable{
	
	private static final long serialVersionUID = 1L;
	
	public RecipeIngredientId(int recipeId, int ingredientId) {
		this.recipeId = recipeId;
		this.ingredientId = ingredientId;
	}

	@Column(name="recipe_id")
	private int recipeId;
	
	@Column(name="ingredient_id")
	private int ingredientId;

	public RecipeIngredientId() {
		super();
	}

	@Override
	public int hashCode() {
		return Objects.hash(ingredientId, recipeId);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		RecipeIngredientId other = (RecipeIngredientId) obj;
		return ingredientId == other.ingredientId && recipeId == other.recipeId;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("RecipeIngredientId [recipeId=");
		builder.append(recipeId);
		builder.append(", ingredientId=");
		builder.append(ingredientId);
		builder.append("]");
		return builder.toString();
	}
	
	
}
