import { RecipeReaction } from "./recipe-reaction";
import { User } from "./user";
import { Comment } from "./comment";
import { RecipeIngredient } from "./recipe-ingredient";


export class Recipe {
  id: number;
  name: string;
  description: string;
  imgUrl: string;
  creationDate: string;
  instructions: string;
  prepTime: number;
  cookTime: number;
  published: boolean;
  user: User;
  comments: Comment[];
  recipeReactions: RecipeReaction[];
  recipeIngredients: RecipeIngredient[];

  constructor(
    id: number = 0,
    name: string = '',
    description: string = '',
    imgUrl: string = '',
    creationDate: string = '',
    instructions: string = '',
    prepTime: number = 0,
    cookTime: number = 0,
    published: boolean = false,
    user: User = new User,
    comments: Comment[] = [],
    recipeReactions: RecipeReaction[] = [],
    recipeIngredients: RecipeIngredient[] = []
  ) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.imgUrl = imgUrl;
    this.creationDate = creationDate;
    this.instructions = instructions;
    this.prepTime = prepTime;
    this.cookTime = cookTime;
    this.published = published;
    this.user = user;
    this.comments = comments;
    this.recipeReactions = recipeReactions;
    this.recipeIngredients = recipeIngredients;
  }
}
