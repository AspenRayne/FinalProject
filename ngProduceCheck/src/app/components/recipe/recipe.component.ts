import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Ingredient } from 'src/app/models/ingredient';
import { Recipe } from 'src/app/models/recipe';
import { Comment } from 'src/app/models/comment';
import { RecipeIngredient } from 'src/app/models/recipe-ingredient';
import { AuthService } from 'src/app/services/auth.service';
import { CommentService } from 'src/app/services/comment.service';
import { RecipeService } from 'src/app/services/recipe.service';

@Component({
  selector: 'app-recipe',
  templateUrl: './recipe.component.html',
  styleUrls: ['./recipe.component.css']
})
export class RecipeComponent implements OnInit {

  constructor(
    private recipeService: RecipeService,
    private commentService: CommentService,
    private auth: AuthService,
    private route: ActivatedRoute,
    private router: Router
  ) { }

  recipes: Recipe[] = [];
  selectedRecipe: Recipe | null = null;
  newRecipe: Recipe = new Recipe;
  ingredient: Ingredient = new Ingredient;
  recipeIngredient: RecipeIngredient[] = [];
  selected: boolean = false;
  searchWord: string = '';
  searchClicked: boolean = false;
  nothingFound: boolean = false;
  noCommentsYet: boolean = false;
  recipeComments: Comment[] = [];
  ngOnInit(): void {

  }

  searchBeenClicked() {
    this.nothingFound = false;
    if (this.searchWord === '') {
      this.searchClicked = false;
      console.log('nothing entered');
      return;
    }
    this.searchClicked = true;
  }
  checkLogin(): boolean {
    return this.auth.checkLogin();
  }
  searchForRecipe(searchWord: string) {
    this.searchBeenClicked();
    this.recipeService.search(searchWord).subscribe(
      {
      next: (data) => {
        this.recipes = data
        if (this.recipes.length === 0) {
          this.nothingFound = true;
        }
        },
      error: (err) => {
        console.error("RecipeComponent.reload(): error loading Recipes");
        console.error(err);
        this.nothingFound = true;
      }
    })
  }

  // Recipe Work
  chooseRecipe(recipe: Recipe) {
    this.selectedRecipe = recipe;
    this.selected = true;
    this.getComments(this.selectedRecipe.id);
  }

  addRecipe(recipe: Recipe) {
    this.recipeService.create
    recipe = new Recipe();
  }
  displayRecipe(recipe: Recipe){
    this.selectedRecipe = recipe;
  }

  updateRecipe(updateRecipe: Recipe){
    this.recipeService.update(updateRecipe).subscribe(
      {
        next: (data) => {
          this.selectedRecipe = data;
          // this.editUser = null;
          // this.reload();
        },
        error: (err) => {
          console.error('RecipeComponent.updateRecipe(): Error updating recipe');
          console.error(err);

        }
    });
  }

  getComments(recipeId: number) {
    if (this.selectedRecipe) {
      this.commentService.show(this.selectedRecipe.id).subscribe({
          next: (data) => {
            this.recipeComments = data
              if (this.recipeComments.length === 0) {
                this.noCommentsYet = true;
              }
            },
          error: (err) => {
            console.error("CommentComponent.getComments(): error loading comments");
            console.error(err);
            this.noCommentsYet = true;
          },
    });
  }
}
  deleteUser(id: number){
    this.recipeService.destroy(id).subscribe(
      {
        next: () => {
          // this.reload();
        },
        error: (err) => {
          console.error('UserComponent.deleteUser(): Error de-activating User');
          console.error(err);


        }
    });
  }

  pushIngredient(ingredient: Ingredient) {
    let tri = new RecipeIngredient();
    tri.ingredient = ingredient;
    tri.recipe = this.newRecipe;
    tri.measurement = '';
    this.recipeIngredient.push(tri);
  }
}
