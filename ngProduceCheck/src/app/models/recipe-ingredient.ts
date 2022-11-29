import { Ingredient } from './ingredient';
import { Recipe } from './recipe';

export class RecipeIngredient {
  id: number;
  recipe: Recipe;
  ingredient: Ingredient;
  measurement: string;

  constructor(
    id: number = 0,
    recipe: Recipe = new Recipe(),
    ingredient: Ingredient = new Ingredient(),
    measurement: string = ''
  ) {
    this.id = id;
    this.recipe = recipe;
    this.ingredient = ingredient;
    this.measurement = measurement;
  }
}
