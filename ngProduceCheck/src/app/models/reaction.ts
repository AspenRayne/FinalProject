import { RecipeReaction } from './recipe-reaction';

export class Reaction {
  id: number;
  emoji: string;
  recipeReactions: RecipeReaction[];

  constructor(
    id: number = 0,
    emoji: string = '',
    recipeReactions: RecipeReaction[] = []
  ) {
    this.id = id;
    this.emoji = emoji;
    this.recipeReactions = recipeReactions;
  }
}
