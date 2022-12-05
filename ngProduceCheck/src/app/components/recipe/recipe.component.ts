import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Ingredient } from 'src/app/models/ingredient';
import { Recipe } from 'src/app/models/recipe';
import { Comment } from 'src/app/models/comment';
import { RecipeIngredient } from 'src/app/models/recipe-ingredient';
import { AuthService } from 'src/app/services/auth.service';
import { CommentService } from 'src/app/services/comment.service';
import { RecipeService } from 'src/app/services/recipe.service';
import { User } from 'src/app/models/user';
import { IngredientService } from 'src/app/services/ingredient.service';
import { Store } from 'src/app/models/store';
import { CustomIngredientStatistics } from 'src/app/models/custom-ingredient-statistics';
import { StoreService } from 'src/app/services/store.service';

@Component({
  selector: 'app-recipe',
  templateUrl: './recipe.component.html',
  styleUrls: ['./recipe.component.css'],
})
export class RecipeComponent implements OnInit {

  constructor(
    private recipeService: RecipeService,
    private commentService: CommentService,
    private ingredientService: IngredientService,
    private storeService: StoreService,
    private auth: AuthService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  recipeId: number = 0;
  recipe: Recipe | null = null;
  currentUser: User = new User();
  recipeComments: Comment[] = [];
  noCommentsYet: boolean = false;
  isCommentUserIdSame: boolean = false;
  newComment: Comment = new Comment();
  emojiCode: string = '\uD83D\uDE00';
  userCanEdit: boolean = false;
  selectedLocation: Store | null = null;
  ingredientStatisticsMap: CustomIngredientStatistics | null = null;
  totalPrice: number = 0;
  zipcode: string = '';
  locationOptions: Store [] | null = null;
  editRecipe: Recipe | null = null;

  showLocationSearch: boolean = false;

  userEditRecipe: boolean = false;



  //   ingredient: Ingredient = new Ingredient;
  //   recipeIngredient: RecipeIngredient[] = [];

  ngOnInit() {
    console.log('initializing');
    let routeId = this.route.snapshot.paramMap.get('id');

    if (routeId) {
      this.recipeId = Number.parseInt(routeId);
    }

    this.recipeService.show(this.recipeId).subscribe({
      next: (data) => {
        this.recipe = data;
        this.getComments(this.recipe.id);
        this.getCurrentUser();
      },
      error: (err) => {
        console.error('RecipeComponent.updateRecipe(): Error updating recipe');
        console.error(err);
      },
    });

    console.log(this.recipeComments);
  }

  /*
   *  USER
   */
  getCurrentUser() {
    this.auth.getLoggedInUser().subscribe({
      next: (data) => {
        this.currentUser = data;
        this.checkUserCanEdit();
      },
      error: (err) => {
        console.error('getCurrentUser() error retriving logged in User');
        console.error(err);
      },
    });
  }

  checkUserCanEdit() {
    let userRecipes: Recipe[] = this.currentUser.userRecipes;
    userRecipes.forEach((element) => {
      if (element.id === this.recipeId) {
        this.userCanEdit = true;
      }
    });
    console.log(this.userCanEdit);
  }

  checkUser(commentId: number, userId: number) {
    if (commentId === userId) {
      this.isCommentUserIdSame = true;
      return true;
    }
    return false;
  }

  checkUserEditRecipe(){

  }

  /*
   *  COMMENTS
   */

  addNewComment(comment: Comment) {
    if (this.recipe) {
      this.commentService.create(this.recipeId, comment).subscribe({
        next: (data) => {
          console.log('added new comment');
          window.location.reload();
        },
        error: (err) => {
          console.error(
            'RecipeComponent.updateRecipe(): Error updating recipe'
          );
          console.error(err);
        },
      });
    }
  }

  replyComment(commentId: number, comment: Comment) {
    if (this.recipe) {
      this.commentService
        .createReply(this.recipeId, commentId, comment)
        .subscribe({
          next: (data) => {
            console.log('added new reply comment');
            window.location.reload();
          },
          error: (err) => {
            console.error(
              'RecipeComponent.updateRecipe(): Error updating recipe'
            );
            console.error(err);
          },
        });
    }
  }

  getComments(recipeId: number) {
    if (this.recipe) {
      this.commentService.show(this.recipeId).subscribe({
        next: (data) => {
          this.recipeComments = data;
          if (this.recipeComments.length === 0) {
            this.noCommentsYet = true;
          }
        },
        error: (err) => {
          console.error(
            'CommentComponent.getComments(): error loading comments'
          );
          console.error(err);
          this.noCommentsYet = true;
        },
      });
    }
  }

  removeComment(commentId: number) {
    if (this.recipe) {
      this.commentService.destroy(this.recipe.id, commentId).subscribe({
        next: () => {
          window.location.reload();
          console.log('comment deleted');
        },
        error: (err) => {
          console.error(
            'CommentComponent.removeComment(): error removing comment from Recipes'
          );
          console.error(err);
        },
      });
    }
  }

  saveRecipe(recipe: Recipe) {
    this.recipeService.saveRecipe(recipe).subscribe({
      next: (data) => {},
      error: (err) => {
        console.error(
          'RecipeComponent.saveRecipe(): error saving recipe' + err
        );
      },
    });
  }

  getAvailabilityAndPrice() {
    if (!this.selectedLocation) {
      return;
    }
    let upcList: string[] = [];
    this.recipe?.recipeIngredients.forEach((element) => {
      upcList.push(element.ingredient.upc);
    });
    this.ingredientService
      .availabilityLookup(this.selectedLocation.locationId, upcList)
      .subscribe({
        next: (data) => {
          // this.totalPrice = this.calculateTotalPrice(data);
          // this.ingredientStatisticsMap = data;
        },
        error: (err) => {
          console.error(
            'RecipeComponent.saveRecipe(): error saving recipe' + err
          );
        },
      });
  }

  // calculateTotalPrice(map: CustomIngredientStatistics ): number{
  //   let price = 0;
  //   map.statMap.forEach((stat) =>{
  //     price += stat.price;
  //   })
  //   return price;
  // }

  selectStore(store: Store) {
    this.selectedLocation = store;
    this.showLocationSearch = false;
    this.getAvailabilityAndPrice()
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

  update(recipe: Recipe) {
    this.recipeService.update(recipe).subscribe({
      next: (data) => {
        this.recipe = data;
        this.userEditRecipe = false;
        this.ngOnInit();
      },
      error: (err) => {
        console.error(
          'RecipeComponent.update(): error updating Recipe'
        );
        console.error(err);
      },
    })
  }

  updateRecipe(recipe: Recipe){
    this.update(recipe)
  }

}
