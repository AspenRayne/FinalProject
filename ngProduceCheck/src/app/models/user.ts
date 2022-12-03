import { TmplAstRecursiveVisitor } from '@angular/compiler';
import { Recipe } from './recipe';
import { RecipeReaction } from './recipe-reaction';
import { Store } from './store';

export class User {
  id: number;
  username: string;
  password: string;
  email: string;
  role: string;
  enabled: boolean;
  createdDate: string;
  loginTimestamp: string;
  aboutMe: string;
  profilePic: string;
  firstName: string;
  lastName: string;
  recipes: Recipe[];
  recipeReactions: RecipeReaction[];
  comments: Comment[];
  stores: Store[];

  constructor(
    id: number = 0,
    username: string = '',
    password: string = '',
    email: string = '',
    role: string = '',
    enabled: boolean = true,
    createdDate: string = '',
    loginTimestamp: string = '',
    aboutMe: string = '',
    profilePic: string = '',
    firstName: string = '',
    lastName: string = '',
    recipes: Recipe[] = [],
    recipeReactions: RecipeReaction[] = [],
    comments: Comment[] = [],
    stores: Store[] = []
  ) {
    this.id = id;
    this.username = username;
    this.password = password;
    this.email = email;
    this.role = role;
    this.enabled = enabled;
    this.createdDate = createdDate;
    this.loginTimestamp = loginTimestamp;
    this.aboutMe = aboutMe;
    this.profilePic = profilePic;
    this.firstName = firstName;
    this.lastName = lastName;
    this.recipes = recipes;
    this.recipeReactions = recipeReactions;
    this.comments = comments;
    this.stores = stores;
  }
}
