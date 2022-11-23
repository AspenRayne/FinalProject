package com.skilldistillery.produce.entities;

import java.util.Objects;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MapsId;

@Entity
public class RecipeIngredient {
	
	@EmbeddedId
	private RecipeIngredientId id;
	
	@ManyToOne
	@JoinColumn(name="recipe_id")
	@MapsId(value= "recipeId")
	private Recipe recipe;
	
	@ManyToOne
	@JoinColumn(name="ingredient_id")
	@MapsId(value="ingredientId")
	private Ingredient ingredient;
	
	private String measurement;

	public RecipeIngredient() {
		super();
	}

	public RecipeIngredientId getId() {
		return id;
	}

	public void setId(RecipeIngredientId id) {
		this.id = id;
	}

	public Recipe getRecipe() {
		return recipe;
	}

	public void setRecipe(Recipe recipe) {
		this.recipe = recipe;
	}

	public Ingredient getIngredient() {
		return ingredient;
	}

	public void setIngredient(Ingredient ingredient) {
		this.ingredient = ingredient;
	}

	public String getMeasurement() {
		return measurement;
	}

	public void setMeasurement(String measurement) {
		this.measurement = measurement;
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
		RecipeIngredient other = (RecipeIngredient) obj;
		return Objects.equals(id, other.id);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("RecipeIngredient [id=");
		builder.append(id);
		builder.append(", measurement=");
		builder.append(measurement);
		builder.append("]");
		return builder.toString();
	}


	
	
}
