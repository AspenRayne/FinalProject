import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Ingredient } from 'src/app/models/ingredient';
import { Recipe } from 'src/app/models/recipe';
import { RecipeIngredient } from 'src/app/models/recipe-ingredient';
import { AuthService } from 'src/app/services/auth.service';
import { RecipeService } from 'src/app/services/recipe.service';

@Component({
  selector: 'app-recipe',
  templateUrl: './recipe.component.html',
  styleUrls: ['./recipe.component.css']
})
export class RecipeComponent implements OnInit {

  constructor(
    private recipeService: RecipeService,
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
  chooseRecipe(recipe: Recipe) {
    this.selectedRecipe = recipe;
    this.selected = true;
  }

  pushIngredient(ingredient: Ingredient) {
    let tri = new RecipeIngredient();
    tri.ingredient = ingredient;
    tri.recipe = this.newRecipe;
    tri.measurement = '';
    this.recipeIngredient.push(tri);
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
}
