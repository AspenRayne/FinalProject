import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Recipe } from 'src/app/models/recipe';
import { User } from 'src/app/models/user';
import { AuthService } from 'src/app/services/auth.service';
import { IngredientService } from 'src/app/services/ingredient.service';

@Component({
  selector: 'app-ingredient',
  templateUrl: './ingredient.component.html',
  styleUrls: ['./ingredient.component.css'],
})
export class IngredientComponent implements OnInit {
  recipe: Recipe | null = null;
  currentUser: User | null = null;

  constructor(
    private ingredientService: IngredientService,
    private auth: AuthService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit(): void {}

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

  searchIngredients(lookup: string, pagination: number, locationId: number) {
    this.ingredientService
      .searchIngredients(lookup, pagination, locationId)
      .subscribe({
        next: (data) => {},

        error: (err) => {
          console.error('IngredientComponent.searchIngredients(): error searching Ingredients');
          console.error(err);
        },
      });
  }
}
