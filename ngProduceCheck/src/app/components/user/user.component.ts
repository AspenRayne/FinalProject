import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Recipe } from 'src/app/models/recipe';
import { User } from 'src/app/models/user';
import { AuthService } from 'src/app/services/auth.service';
import { RecipeService } from 'src/app/services/recipe.service';
import { UserService } from 'src/app/services/user.service';

@Component({
  selector: 'app-user',
  templateUrl: './user.component.html',
  styleUrls: ['./user.component.css']
})
export class UserComponent implements OnInit {

  public loggedInUser: User | null = null;

  recipe: Recipe | null = null;
  recipes: Recipe[] = [];
  user: User | null = null;
  selected: User | null = null;
  users: User[] = [];
  editUser: User | null = null;

  constructor(
    private recipeService: RecipeService,
    private auth: AuthService,
    private userService: UserService,
    private route: ActivatedRoute,
    private router: Router
  ) { }

  ngOnInit(): void {
    // let routeId = this.route.snapshot.paramMap.get('id');
    // console.log(routeId);
    // if(routeId && !this.selected){
    //   let userId = Number.parseInt(routeId);
    //   if(isNaN(userId)){
    //     this.router.navigateByUrl('invalidId');
    //   }else{
    //     this.userService.show(userId).subscribe({
    //       next: (user) => {
    //         this.selected = user;
    //       },
    //       error: (fail) => {
    //         console.error('UserService.ngOnInit: User not found')
    //         this.router.navigateByUrl('userNotFound');

    //       }
    //     })
    //   }
    // }

    // this.reload();
    console.log('inside init');

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
      console.log("before cond");

      // if(this.user){
        console.log("inside cond");

        this.getUserRecipes();
        console.log(this.recipes);

      // }

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
      },
      error: (err) => {
        console.error("UserComponent.reload(): error loading Users");
        console.error(err);

      }
    })
  }

  displayUser(user: User){
    this.selected = user;
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
}
