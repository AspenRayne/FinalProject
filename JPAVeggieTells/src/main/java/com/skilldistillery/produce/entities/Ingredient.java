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
public class Ingredient {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	
	private String name;
	
	private String description;
	
	private String upc;
	
	@Column(name="img_url")
	private String imgUrl;
	
	private String plu;

	@OneToMany(mappedBy="ingredient")
	List <RecipeIngredient> recipeIngredients;
	
	public Ingredient() {
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

	public String getUpc() {
		return upc;
	}

	public void setUpc(String upc) {
		this.upc = upc;
	}

	public String getImgUrl() {
		return imgUrl;
	}

	public void setImgUrl(String imgUrl) {
		this.imgUrl = imgUrl;
	}

	public String getPlu() {
		return plu;
	}

	public void setPlu(String plu) {
		this.plu = plu;
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
			if (ingredient.getIngredient() != null) {
				ingredient.getIngredient().getRecipeIngredients().remove(ingredient);
			}
			ingredient.setIngredient(this);
		}
	}

	public void removeRecipeIngredient(RecipeIngredient ingredient) {
		if (recipeIngredients != null) {
			recipeIngredients.remove(ingredient);
			ingredient.setIngredient(null);
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
		Ingredient other = (Ingredient) obj;
		return id == other.id;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("Ingredient [id=");
		builder.append(id);
		builder.append(", name=");
		builder.append(name);
		builder.append(", description=");
		builder.append(description);
		builder.append(", upc=");
		builder.append(upc);
		builder.append(", imgUrl=");
		builder.append(imgUrl);
		builder.append(", plu=");
		builder.append(plu);
		builder.append("]");
		return builder.toString();
	}
	
	

}
