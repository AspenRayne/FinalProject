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

  recipeId: number = 0;
  recipe: Recipe | null = null;
//   currentUser: User = new User();

//   recipes: Recipe[] = [];
//   selectedRecipe: Recipe | null = null;
//   newRecipe: Recipe = new Recipe;

//   ingredient: Ingredient = new Ingredient;
//   recipeIngredient: RecipeIngredient[] = [];

//   selected: boolean = false;
//   searchWord: string = '';
//   searchClicked: boolean = false;
//   nothingFound: boolean = false;
//   noCommentsYet: boolean = false;
//   isCommentUserIdSame: boolean = false;
//   newComment: Comment = new Comment;
//   recipeComments: Comment[] = [];
ngOnInit() {
      console.log('initializing')
      let routeId = this.route.snapshot.paramMap.get('id');

      if (routeId) {
       this.recipeId = Number.parseInt(routeId);
      }
       console.log(this.recipeId);

       this.recipeService.show(this.recipeId).subscribe({
        next: (data) => {
            this.recipe = data;
            console.log(this.recipe);
            },
        error: (err) => {
            console.error('RecipeComponent.updateRecipe(): Error updating recipe');
            console.error(err);
            }
        });
        console.log(this.recipe);
      }

//   getCurrentUser() {
//     this.auth.getLoggedInUser().subscribe({
//       next: (data) => {
//         this.currentUser = data;
//       },
//       error: (err) => {
//         console.error("getCurrentUser() error retriving logged in User");
//         console.error(err);
//       }

//     })
//   }

//   searchBeenClicked() {
//     this.nothingFound = false;
//     if (this.searchWord === '') {
//       this.searchClicked = false;
//       console.log('nothing entered');
//       return;
//     }
//     this.searchClicked = true;
//   }
//   checkLogin(): boolean {
//     return this.auth.checkLogin();
//   }
//   searchForRecipe(searchWord: string) {
//     this.searchBeenClicked();
//     this.recipeService.search(searchWord).subscribe(
//       {
//       next: (data) => {
//         this.recipes = data
//         if (this.recipes.length === 0) {
//           this.nothingFound = true;
//         }
//         },
//       error: (err) => {
//         console.error("RecipeComponent.reload(): error loading Recipes");
//         console.error(err);
//         this.nothingFound = true;
//       }
//     });
//   }

//   // Recipe Work
//   chooseRecipe(recipe: Recipe) {
//     this.selectedRecipe = recipe;
//     this.selected = true;
//     this.getComments(this.selectedRecipe.id);
//   }


//   addNewComment(comment: Comment) {
//     if (this.selectedRecipe) {
//       this.commentService.create(this.selectedRecipe.id, comment).subscribe(
//         {
//           next: (data) => {
//             console.log("added new comment");
//           },
//           error: (err) => {
//             console.error('RecipeComponent.updateRecipe(): Error updating recipe');
//             console.error(err);

//           }
//       });
//     }
//     window.location.reload();
//     this.selected = true;
//     this.getComments(this.selectedRecipe!.id);
//     this.searchClicked = true;
//     this.nothingFound = false;

//   }


//   getComments(recipeId: number) {
//     if (this.selectedRecipe) {
//       this.commentService.show(this.selectedRecipe.id).subscribe({
//           next: (data) => {
//             this.recipeComments = data
//               if (this.recipeComments.length === 0) {
//                 this.noCommentsYet = true;
//               }
//             },
//           error: (err) => {
//             console.error("CommentComponent.getComments(): error loading comments");
//             console.error(err);
//             this.noCommentsYet = true;
//             },
//       });
//     }
//   }

//   removeComment(commentId: number) {
//     if (this.selectedRecipe) {
//     this.commentService.destroy(this.selectedRecipe.id, commentId).subscribe(
//       {
//         next: () => {
//           window.location.reload();
//           console.log('comment deleted')
//           },
//         error: (err) => {
//           console.error("CommentComponent.removeComment(): error removing comment from Recipes");
//           console.error(err);
//           this.nothingFound = true;
//         }
//       });
//     }
//   }


//   checkUser(commentId: number, userId: number) {
//       if (commentId === userId) {
//         this.isCommentUserIdSame = true; return true;
//       }
//       return false;
//   }


}
