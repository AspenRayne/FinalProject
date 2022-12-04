import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Ingredient } from 'src/app/models/ingredient';
import { Recipe } from 'src/app/models/recipe';
import { Store } from 'src/app/models/store';
import { User } from 'src/app/models/user';
import { AuthService } from 'src/app/services/auth.service';
import { IngredientService } from 'src/app/services/ingredient.service';
import { RecipeService } from 'src/app/services/recipe.service';
import { StoreService } from 'src/app/services/store.service';

@Component({
  selector: 'app-ingredient',
  templateUrl: './ingredient.component.html',
  styleUrls: ['./ingredient.component.css'],
})
export class IngredientComponent implements OnInit {
  recipe: Recipe | null = null;
  currentUser: User | null = null;
  lookup: string = '';
  currentPage: number = 1;
  totalItemsReturned: number = 0;
  selectedLocation: Store | null = null;
  locationOptions: Store [] | null = null;
  zipcode: string = "";
  apiIngredients: Ingredient[] | null = null;
  recommendedIngredients: Ingredient[] | null = null;

  constructor(
    private recipeService: RecipeService,
    private ingredientService: IngredientService,
    private auth: AuthService,
    private route: ActivatedRoute,
    private storeService: StoreService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.route.params.subscribe((params) => {
      let recipeId = params['recipe'];
      this.recipeService.show(recipeId).subscribe({
        next: (data) => {
          this.recipe = data;
          this.getCurrentUser()
        },
        error: (err) => {
          console.error('ngOnInit() error retriving recipe');
          console.error(err);
        },
      });
    });
  }

  getRecipe(recipe: Recipe) {}

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

  getUserStores(): Store[] {
    if (this.currentUser === null) {
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
    } else {
      locationId = this.selectedLocation.locationId;
    }

    this.ingredientService
      .searchIngredients(this.lookup, this.currentPage, locationId)
      .subscribe({
        next: (data) => {
          console.log(data);
          this.apiIngredients = data.apiData;
          this.recommendedIngredients = data.recommendedIngredients;
          this.currentPage = data.pagination.start + data.pagination.limit -1;
          this.totalItemsReturned = data.pagination.total;
          console.log(this.recommendedIngredients);
        },

        error: (err) => {
          console.error(
            'IngredientComponent.searchIngredients(): error searching Ingredients'
          );
          console.error(err);
        },
      });
  }

  addIngredientToRecipe(ingredient: Ingredient) {
    if (this.recipe) {
      this.recipeService.addIngredient(this.recipe.id, ingredient).subscribe({
        next: (data) => {
          console.log(data);
        },
        error: (err) => {
          console.error(
            'IngredientComponent.searchIngredients(): error searching Ingredients'
          );
          console.error(err);
        },
      });
    }
  }

  searchStoresByZipcode(){
    this.storeService.getStoreLocations(this.zipcode).subscribe({
      next: (data) => {
        this.locationOptions = data;
        console.log(data);
      },
      error: (err) => {
        console.error(
          'IngredientComponent.searchStoresByZipcode): error searching locations'
        );
        console.error(err);
      },
    })
  }
  saveStoreToUser(store: Store){
    this.storeService.setFavoriteStore(store).subscribe({
      next: (data) => {
        this.selectedLocation = data;
      },
      error: (err) => {
        console.error(
          'IngredientComponent.saveStoreToUser(): error saving store to user'
        );
        console.error(err);
      },
    })
  }
}
