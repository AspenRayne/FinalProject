import { Ingredient } from "./ingredient";

export class Category {
  id: number;
  name: string;
  ingredients: Ingredient[];

  constructor(
    id: number = 0,
    name: string = '',
    ingredients: Ingredient[] = []
  ) {
    this.id = id;
    this.name = name;
    this.ingredients = ingredients;
  }
}
