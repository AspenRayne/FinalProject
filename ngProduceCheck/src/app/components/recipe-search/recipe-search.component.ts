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
  templateUrl: './recipe-search.component.html',
  styleUrls: ['./recipe-search.component.css']
})
export class RecipeSearchComponent implements OnInit {

  constructor(
    private recipeService: RecipeService,
    private commentService: CommentService,
    private auth: AuthService,
    private route: ActivatedRoute,
    private router: Router
  ) { }

  currentUser: User = new User();

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
  isCommentUserIdSame: boolean = false;
  replyToComment: boolean = false;

  newComment: Comment = new Comment;
  recipeComments: Comment[] = [];

  ngOnInit(): void {

    this.getCurrentUser();
    console.log(this.currentUser?.username);
  }

  getCurrentUser() {
    this.auth.getLoggedInUser().subscribe({
      next: (data) => {
        this.currentUser = data;
      },
      error: (err) => {
        console.error("getCurrentUser() error retriving logged in User");
        console.error(err);
      }

    })
  }

  sendToRecipe(id: number) {
    this.router.navigateByUrl('/recipe/' + id);
  }
  searchBeenClicked() {
    this.nothingFound = false;
    if (this.searchWord === '') {
      this.searchClicked = false;
      console.log('nothing entered');
      this.nothingFound = true;
      return;
    }
    this.searchClicked = true;
    this.searchForRecipe(this.searchWord);
  }
  checkLogin(): boolean {
    return this.auth.checkLogin();
  }


  searchForRecipe(searchWord: string) {
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
    });
  }

  chooseRecipe(recipe: Recipe) {
    this.selectedRecipe = recipe;
    this.selected = true;
    this.getComments(this.selectedRecipe.id);
  }
  addNewComment(comment: Comment) {
    if (this.selectedRecipe) {
      this.commentService.create(this.selectedRecipe.id, comment).subscribe(
        {
          next: (data) => {
            console.log("added new comment");
          },
          error: (err) => {
            console.error('RecipeComponent.updateRecipe(): Error updating recipe');
            console.error(err);

          }
      });
    }
    window.location.reload();
    this.selected = true;
    this.getComments(this.selectedRecipe!.id);
    this.searchClicked = true;
    this.nothingFound = false;

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

  removeComment(commentId: number) {
    if (this.selectedRecipe) {
    this.commentService.destroy(this.selectedRecipe.id, commentId).subscribe(
      {
        next: () => {
          window.location.reload();
          console.log('comment deleted')
          },
        error: (err) => {
          console.error("CommentComponent.removeComment(): error removing comment from Recipes");
          console.error(err);
          this.nothingFound = true;
        }
      });
    }
  }

  replyButtonClicked(oldComment: Comment) {

    // pass in the old comment
    // set the new comment as part of its comment


  }

  replyComment(commentId: number) {
  }




}
