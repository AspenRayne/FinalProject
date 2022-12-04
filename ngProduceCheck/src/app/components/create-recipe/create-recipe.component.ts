import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Ingredient } from 'src/app/models/ingredient';
import { Recipe } from 'src/app/models/recipe';
import { RecipeIngredient } from 'src/app/models/recipe-ingredient';
import { AuthService } from 'src/app/services/auth.service';
import { RecipeService } from 'src/app/services/recipe.service';

@Component({
  selector: 'app-create-recipe',
  templateUrl: './create-recipe.component.html',
  styleUrls: ['./create-recipe.component.css']
})
export class CreateRecipeComponent implements OnInit {

  constructor(
    private auth: AuthService,
    private recipeService: RecipeService,
    private route: ActivatedRoute,
    private router: Router
  ) { }

  recipes: Recipe[] = [];
  selectedRecipe: Recipe | null = null;
  newRecipe: Recipe = new Recipe;
  ingredient: Ingredient = new Ingredient;
  recipeIngredient: RecipeIngredient[] = [];


  ngOnInit(): void {
    if (this.checkLogin())
    {
    this.reload();
    }
  }

  checkLogin(): boolean {
    return this.auth.checkLogin();
  }
  reload(){
    this.recipeService.index().subscribe(
      {
      next: (data) => {
        this.recipes = data
      },
      error: (err) => {
        console.error("RecipeComponent.reload(): error loading Recipes");
        console.error(err);

      }
    })
  }

  pushIngredient(ingredient: Ingredient) {
    let tri = new RecipeIngredient();
    tri.ingredient = ingredient;
    tri.recipe = this.newRecipe;
    tri.measurement = '';
    this.recipeIngredient.push(tri);
  }
  addRecipe(recipe: Recipe) {
    this.recipeService.create(recipe).subscribe(
      {
        next: (data) => {
          this.selectedRecipe = data;
          // this.editUser = null;

          this.router.navigateByUrl('/recipe/' + this.selectedRecipe.id);
        },
        error: (err) => {
          console.error('RecipeComponent.updateRecipe(): Error updating recipe');
          console.error(err);

        }
    });
    this.newRecipe = new Recipe();
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
          this.reload();
        },
        error: (err) => {
          console.error('RecipeComponent.updateRecipe(): Error updating recipe');
          console.error(err);

        }
    });
  }
  deleteRecipe(id: number){
    this.recipeService.destroy(id).subscribe(
      {
        next: () => {
          this.reload();
        },
        error: (err) => {
          console.error('RecipeComponent.deleteRecipe(): Error de-activating Recipe');
          console.error(err);


        }
    });
  }
}
