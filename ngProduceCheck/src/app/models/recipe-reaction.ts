import { Reaction } from './reaction';
import { Recipe } from './recipe';
import { User } from './user';

export class RecipeReaction {
  id: number;
  recipe: Recipe;
  user: User;
  reactionDate: string;
  reaction: Reaction;

  constructor(
    id: number = 0,
    recipe: Recipe,
    user: User,
    reactionDate: string = '',
    reaction: Reaction = new Reaction()
  ) {
    this.id = id;
    this.recipe = recipe;
    this.user = user;
    this.reactionDate = reactionDate;
    this.reaction = reaction;
  }
}
