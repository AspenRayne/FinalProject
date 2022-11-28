import { Ingredient } from "./ingredient";
import { Recipe } from "./recipe";

export class RecipeIngredient {
  id: number;
  recipe: Recipe;
  ingredient: Ingredient = new Ingredient;
  measurement: string | undefined;


  constructor(
    id: number = 0,
    recipe: Recipe = new Recipe,
    ingredient: Ingredient = new Ingredient,
    measurement?: string | undefined
  )
  {
    this.id = id;
    this.recipe = recipe;
    this.ingredient = ingredient;
    this.measurement = measurement;
  }
}
