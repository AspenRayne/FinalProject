import { RecipeIngredient } from "./recipe-ingredient";

export class Ingredient {
  id: number;
  name: string | undefined;
  description: string | undefined;
  upc: string | undefined;
  imgUrl: string | undefined;
  plu: string | undefined;
  recipeIngredients: RecipeIngredient[];

  constructor(
    id: number = 0,
    name?: string | undefined,
    description?: string | undefined,
    upc?: string | undefined,
    imgUrl?: string | undefined,
    plu?: string | undefined,
    recipeIngredients: RecipeIngredient[] = []
  ) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.upc = upc,
    this.imgUrl = imgUrl;
    this.plu = plu;
    this.recipeIngredients = recipeIngredients;
  }
}
