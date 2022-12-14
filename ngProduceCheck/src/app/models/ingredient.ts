import { Category } from './category';
import { RecipeIngredient } from './recipe-ingredient';

export class Ingredient {
  id: number;
  name: string;
  description: string;
  upc: string;
  imgUrl: string;
  plu: string;
  recipeIngredients: RecipeIngredient[];
  categories: Category[];

  constructor(
    id: number = 0,
    name: string = '',
    description: string = '',
    upc: string = '',
    imgUrl: string = '',
    plu: string = '',
    recipeIngredients: RecipeIngredient[] = [],
    categories: Category[] = []
  ) {
    this.id = id;
    this.name = name;
    this.description = description;
    (this.upc = upc), (this.imgUrl = imgUrl);
    this.plu = plu;
    this.recipeIngredients = recipeIngredients;
    this.categories = categories;
  }
}
