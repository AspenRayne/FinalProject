import { Recipe } from './recipe';
import { User } from './user';

export class RecipeReaction {
  id: number;
  recipe: Recipe;
  user: User;
  reactionDate: string;

  constructor(
    id: number = 0,
    recipe: Recipe = new Recipe(),
    user: User = new User(),
    reactionDate: string = ''
  ) {
    this.id = id;
    this.recipe = recipe;
    this.user = user;
    this.reactionDate = reactionDate;
  }
}
