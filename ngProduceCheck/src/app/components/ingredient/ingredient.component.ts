import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Ingredient } from 'src/app/models/ingredient';
import { Recipe } from 'src/app/models/recipe';
import { Store } from 'src/app/models/store';
import { User } from 'src/app/models/user';
import { AuthService } from 'src/app/services/auth.service';
import { IngredientService } from 'src/app/services/ingredient.service';
import { RecipeService } from 'src/app/services/recipe.service';

@Component({
  selector: 'app-ingredient',
  templateUrl: './ingredient.component.html',
  styleUrls: ['./ingredient.component.css'],
})
export class IngredientComponent implements OnInit {
  recipe: Recipe;
  currentUser: User | null = null;
  lookup: string = '';
  currentPage: number = 1;
  selectedLocation: Store | null = null;

  constructor(
    private recipeService: RecipeService,
    private ingredientService: IngredientService,
    private auth: AuthService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.recipe = new Recipe();
  }

  getCurrentUser() {
    this.auth.getLoggedInUser().subscribe({
      next: (data) => {
        this.currentUser = data;
      },
      error: (err) => {
        console.error('getCurrentUser() error retriving logged in User');
        console.error(err);
      },
    });
  }

  checkLogin(): boolean {
    return this.auth.checkLogin();
  }

  getUserStores(): Store []{
    if(this.currentUser === null){
      return [];
    }
    return this.currentUser.stores;
  }

  selectStore(store: Store) {
    this.selectedLocation = store;
  }

  searchIngredients() {
    let locationId: number;
    if (this.selectedLocation === null) {
      return;
    } else{
      locationId = this.selectedLocation.locationId;
    }

    this.ingredientService
      .searchIngredients(this.lookup, this.currentPage, locationId)
      .subscribe({
        next: (data) => {
          console.log(data);
        },

        error: (err) => {
          console.error('IngredientComponent.searchIngredients(): error searching Ingredients');
          console.error(err);
        },
      });
  }

  addIngredientToRecipe(ingredient: Ingredient){

    this.recipeService.addIngredient(this.recipe.id, ingredient)
    .subscribe({
      next: (data) => {
        console.log(data);
      },
      error: (err) => {
        console.error('IngredientComponent.searchIngredients(): error searching Ingredients');
        console.error(err);
      },
    })
  }

}
