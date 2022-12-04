import { Ingredient } from './ingredient';

export class CustomIngredientResponse {
  pagination: {
    total: number;
    start: number;
    limit: number;
  };
  apiData: Ingredient[];
  recommendedIngredient: Ingredient[];

  constructor(
    pagination: {
      total: number;
      start: number;
      limit: number;
    } ,
    apiData: Ingredient[] = [],
    recommendedIngredients: Ingredient[] = []
  ) {
    this.pagination = pagination;
    this.apiData = apiData;
    this.recommendedIngredient = recommendedIngredients;
  }
}
