import { RecipeReaction } from "./recipe-reaction";
import { User } from "./user";
import { Comment } from "./comment";
import { RecipeIngredient } from "./recipe-ingredient";

export class Recipe {
  id: number;
  name: string | undefined;
  description: string | undefined;
  imgUrl: string | undefined;
  creationDate: string | undefined;
  instruction: string | undefined;
  prepTime: number;
  cookTime: number;
  users: User[];
  comments: Comment[];
  recipeReactions: RecipeReaction[];
  recipeIngredients: RecipeIngredient[];

  constructor(
    id: number = 0,
    name?: string | undefined,
    description?: string | undefined,
    imgUrl?: string | undefined,
    creationDate?: string | undefined,
    instruction?: string | undefined,
    prepTime: number = 0,
    cookTime: number = 0,
    users: User[] = [],
    comments: Comment[] = [],
    recipeReactions: RecipeReaction[] = [],
    recipeIngredients: RecipeIngredient[] = []) {

          this.id = id;
          this.name = name;
          this.description = description;
          this.imgUrl = imgUrl;
          this.creationDate = creationDate;
          this.instruction = instruction;
          this.prepTime = prepTime;
          this.cookTime = cookTime;
          this.users = users;
          this.comments = comments;
          this.recipeReactions = recipeReactions;
          this.recipeIngredients = recipeIngredients;
    }


}
