import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Recipe } from 'src/app/models/recipe';
import { User } from 'src/app/models/user';
import { AuthService } from 'src/app/services/auth.service';
import { CommentService } from 'src/app/services/comment.service';
import { RecipeService } from 'src/app/services/recipe.service';
import { UserService } from 'src/app/services/user.service';
import { Comment } from 'src/app/models/comment';

@Component({
  selector: 'app-user-profile',
  templateUrl: './user-profile.component.html',
  styleUrls: ['./user-profile.component.css']
})
export class UserProfileComponent implements OnInit {

  public loggedInUser: User | null = null;
  currentUser: User = new User();

  selectedRecipe: Recipe | null = null;
  recipe: Recipe | null = null;
  recipes: Recipe[] = [];
  user: User | null = null;
  selectedUser: User | null = null;
  selectedRec: boolean = false;
  users: User[] = [];
  editUser: User | null = null;
  recipeComments: Comment[] = [];
  noCommentsYet: boolean = false;
  newComment: Comment = new Comment;
  isCommentUserIdSame: boolean = false;
  selected: boolean = false;
  nothingFound: boolean = false;
  searchClicked: boolean = false;
  allRec: Recipe[] = [];

  constructor(
    private commentService: CommentService,
    private recipeService: RecipeService,
    private auth: AuthService,
    private userService: UserService,
    private route: ActivatedRoute,
    private router: Router
  ) { }

  ngOnInit(): void {
    let routeId = this.route.snapshot.paramMap.get('id');
    console.log(routeId);
    if(routeId && !this.selectedUser){
      let userId = Number.parseInt(routeId);
      if(isNaN(userId)){
        this.router.navigateByUrl('invalidId');
      }else{
        this.userService.show(userId).subscribe({
          next: (user) => {
            this.selectedUser= user;
            console.log(this.selectedUser);
          },
          error: (fail) => {
            console.error('UserService.ngOnInit: User not found')
            this.router.navigateByUrl('userNotFound');

          }
        })
      }
    }

    this.getAllUserRecipes();
    this.auth.getLoggedInUser().subscribe(
      {
        next: (data) => {
          this.user = data
        },
        error: (err) => {
          console.error("UserComponent.reload(): error loading Users");
          console.error(err);

        }
      });
  }
  setEditUser() {
    this.auth.getLoggedInUser().subscribe(
      {
        next: (data) => {
          this.editUser = data
        },
        error: (err) => {
          console.error("UserComponent.reload(): error loading Users");
          console.error(err);

        }
      })

  }

  showAll(){
    this.userService.index().subscribe(
      {
      next: (data) => {
        this.users = data
        this.users.shift();
      },
      error: (err) => {
        console.error("UserComponent.reload(): error loading Users");
        console.error(err);

      }
    })
  }

  displayUser(user: User){
    this.selectedUser = user;
  }

  updateUser(editUser: User){
    console.log(editUser);

    this.userService.update(editUser).subscribe(
      {
        next: (data) => {
          this.user= data;
          this.editUser = null;
          // this.reload();
        },
        error: (err) => {
          console.error('UserComponent.updateUser(): Error updating User');
          console.error(err);

        }
    });
  }
  deleteUser(id: number){
    this.userService.destroy(id).subscribe(
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
  checkLogin(): boolean {
    return this.auth.checkLogin();
  }

  getCurrentUser(): void {
     this.auth.getLoggedInUser().subscribe(
      {
        next: (data) => {
          this.loggedInUser= data;
          console.log(this.loggedInUser);

          // this.editUser = null;
          // this.reload();
        },
        error: (err) => {
          console.error('NavigationComponent.getCurrentUser(): Error retrieving Logged In User');
          console.error(err);

        }
      });


    }
    isAdmin(): boolean {
        if(this.checkLogin()){
          if(this.loggedInUser?.role === 'ADMIN'){
            return true;
          }
        }
        return false;
    }

    getUserRecipes(){
      this.recipeService.showRecipeByUser().subscribe(
        {
          next: (data) => {
            this.recipes = data;
            // this.editUser = null;
            // this.reload();
          },
          error: (err) => {
            console.error('RecipeComponent.showRecipeByUser(): Error retrieving User recipes');
            console.error(err);

          }
      })
    }
    getAllUserRecipes(){
      this.recipeService.index().subscribe(
        {
          next: (data) => {
            this.allRec = data;
            // this.editUser = null;
            // this.reload();
          },
          error: (err) => {
            console.error('RecipeComponent.showRecipeByUser(): Error retrieving User recipes');
            console.error(err);

          }
      })
    }
    chooseRecipe(recipe: Recipe) {
      this.selectedRecipe = recipe;
      this.selectedRec = true;
      this.getComments(this.selectedRecipe.id);
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
    checkUser(commentId: number, userId: number) {
      if (commentId === userId) {
        this.isCommentUserIdSame = true; return true;
      }
      return false;
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

}
