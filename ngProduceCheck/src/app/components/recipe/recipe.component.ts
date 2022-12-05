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

@Component({
  selector: 'app-recipe',
  templateUrl: './recipe.component.html',
  styleUrls: ['./recipe.component.css'],
})
export class RecipeComponent implements OnInit {
  constructor(
    private recipeService: RecipeService,
    private commentService: CommentService,
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
  newComment: Comment = new Comment;
  emojiCode: string = '\uD83D\uDE00';
  userCanEdit: boolean = false;

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
      this.commentService.createReply(this.recipeId, commentId, comment).subscribe({
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

  saveRecipe(recipe: Recipe){
    this.recipeService.saveRecipe(recipe).subscribe({
      next: () => {
      },
      error: (err) => {
        console.error(
          'RecipeComponent.saveRecipe(): error saving recipe' + err
        );
      }
    })
  }
}
