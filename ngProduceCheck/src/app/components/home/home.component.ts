import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Recipe } from 'src/app/models/recipe';
import { User } from 'src/app/models/user';
import { AuthService } from 'src/app/services/auth.service';
import { CommentService } from 'src/app/services/comment.service';
import { RecipeService } from 'src/app/services/recipe.service';
import { UserService } from 'src/app/services/user.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

  constructor(
    private commentService: CommentService,
    private recipeService: RecipeService,
    private auth: AuthService,
    private userService: UserService,
    private route: ActivatedRoute,
    private router: Router
  ) { }

  homeRecipeArray: Recipe[] = [];
  homeRecipeDisplayArray: Recipe[] = [];

  /*
  * Display Recipes for the Main Page
  */
  displayRecipe1 = new Recipe();
  displayRecipe2 = new Recipe();
  displayRecipe3 = new Recipe();

  ngOnInit(): void {
    this.recipeService.index().subscribe(
      {
        next: (data) => {
          this.homeRecipeArray = data;
          this.populateDisplay(this.homeRecipeArray);
        },
        error: (err) => {
          console.error("UserComponent.reload(): error loading Users");
          console.error(err);
        }
      });

  }

  populateDisplay(recipe: Recipe[]) {
    for (let i = 0 ; i < 3 ; i++) {
      this.homeRecipeDisplayArray[i] = recipe[(Math.floor(Math.random() * this.homeRecipeArray.length))]
      console.log(this.homeRecipeDisplayArray[i]);
        this.displayRecipe1 = this.homeRecipeDisplayArray[0];
        this.displayRecipe2 = this.homeRecipeDisplayArray[1];
        this.displayRecipe3 = this.homeRecipeDisplayArray[2];

    }

  }


  checkLogin(): boolean {
    return this.auth.checkLogin();
  }
}
