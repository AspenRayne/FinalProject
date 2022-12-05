import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, throwError, Observable } from 'rxjs';
import { Ingredient } from '../models/ingredient';
import { Recipe } from '../models/recipe';
import { RecipeIngredient } from '../models/recipe-ingredient';
import { AuthService } from './auth.service';

@Injectable({
  providedIn: 'root',
})
export class RecipeService {
  private baseUrl = 'http://localhost:8088/api/recipes';
  private indexUrl = 'http://localhost:8088/api/allrecipes';
  private searchUrl = 'http://localhost:8088/api/recipes/search';
  private unsaveUrl = 'http://localhost:8088/api/favoritedRecipes';

  constructor(private http: HttpClient, private auth: AuthService) {}

  getHttpOptions() {
    let options = {
      headers: {
        Authorization: 'Basic ' + this.auth.getCredentials(),
        'X-Requested-With': 'XMLHttpRequest',
      },
    };
    return options;
  }
  index(): Observable<Recipe[]> {
    return this.http.get<Recipe[]>(this.indexUrl, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(
          () =>
            new Error('RecipeService.index():error retrieving recipes: ' + err)
        );
      })
    );
  }
  create(recipe: Recipe) {
    return this.http
      .post<Recipe>(this.baseUrl, recipe, this.getHttpOptions())
      .pipe(
        catchError((err: any) => {
          console.log(err);
          return throwError(() =>
            Error('RecipeService.create(): error creating a new recipe item')
          );
        })
      );
  }
  show(recipeId: number): Observable<Recipe> {
    return this.http
      .get<Recipe>(this.baseUrl + '/' + recipeId, this.getHttpOptions())
      .pipe(
        catchError((err: any) => {
          console.log(err);
          return throwError(
            () =>
              new Error('RecipeService.show():error retrieving recipe : ' + err)
          );
        })
      );
  }
  showRecipeByUser(): Observable<Recipe[]> {
    return this.http.get<Recipe[]>(this.baseUrl, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(
          () =>
            new Error('RecipeService.index():error retrieving recipes: ' + err)
        );
      })
    );
  }
  update(recipe: Recipe) {
    // USer HAS TOO MUCH DATA CANT BE SERIALIZED BY SERVER.
    let reqData = {
      cookTime: recipe.cookTime,
      name: recipe.name,
      id: recipe.id,
      description: recipe.description,
      imgUrl: recipe.imgUrl,
      creationDate: recipe.creationDate,
      instructions: recipe.instructions,
      prepTime: recipe.prepTime,
      published: recipe.published,
      // "user": recipe.user
    };
    return this.http
      .put<Recipe>(
        this.baseUrl + '/' + recipe.id,
        reqData,
        this.getHttpOptions()
      )
      .pipe(
        catchError((err: any) => {
          console.log(err);
          return throwError(
            () =>
              new Error('RecipeService.update():error updating recipe: ' + err)
          );
        })
      );
  }
  search(keyword: string): Observable<Recipe[]> {
    return this.http
      .get<Recipe[]>(this.searchUrl + '/' + keyword, this.getHttpOptions())
      .pipe(
        catchError((err: any) => {
          console.log(err);
          return throwError(
            () =>
              new Error(
                'RecipeService.index():error retrieving recipes: ' + err
              )
          );
        })
      );
  }
  destroy(id: number) {
    return this.http
      .delete<void>(this.baseUrl + '/' + id, this.getHttpOptions())
      .pipe(
        catchError((err: any) => {
          console.log(err);
          return throwError(
            () =>
              new Error(
                'RecipeService.destroy(): error de-activating recipe: ' + err
              )
          );
        })
      );
  }
  saveRecipe(recipe: Recipe) {
    return this.http
      .post<Recipe>(`${this.baseUrl}/${recipe.id}`, null, this.getHttpOptions())
      .pipe(
        catchError((err: any) => {
          console.log(err);
          return throwError(() =>
            Error('RecipeService.saveRecipe(): error saving recipe')
          );
        })
      );
  }

  unsaveRecipe(id: number) {
    return this.http
      .delete<void>(`${this.unsaveUrl}/${id}`, this.getHttpOptions())
      .pipe(
        catchError((err: any) => {
          console.log(err);
          return throwError(
            () =>
              new Error(
                'RecipeService.unsaveRecipe(): error unsaving recipe: ' + err
              )
          );
        })
      );
  }

  addIngredient(recipeId: number, ingredient: Ingredient): Observable<Recipe> {
    return this.http
      .put<Recipe>(
        `${this.baseUrl}/addIngredient/${recipeId}`,
        ingredient,
        this.getHttpOptions()
      )
      .pipe(
        catchError((err: any) => {
          console.log(err);
          return throwError(
            () =>
              new Error(
                'RecipeService.addIngredient():error adding ingredient to recipe: ' +
                  err
              )
          );
        })
      );
  }

  unsaveIngredient(recipeId: number, ingredientId: number): Observable<Recipe> {
    return this.http
      .delete<Recipe>(
        `${this.baseUrl}/removeIngredient/${recipeId}/${ingredientId}`,
        this.getHttpOptions()
      )
      .pipe(
        catchError((err: any) => {
          console.log(err);
          return throwError(
            () =>
              new Error(
                'RecipeService.unsaveIngredient():error unsaving ingredient: ' +
                  err
              )
          );
        })
      );
  }

  addMeasurement(
    recipe: Recipe,
    ingredient: Ingredient,
    recipeIngredient: RecipeIngredient
  ): Observable<RecipeIngredient> {
    return this.http
      .put<RecipeIngredient>(
        `${this.baseUrl}/${recipe.id}/${ingredient.id}`,
        recipeIngredient,
        this.getHttpOptions()
      )
      .pipe(
        catchError((err: any) => {
          console.log(err);
          return throwError(
            () =>
              new Error(
                'RecipeService.addMeasurement():error saving measurement: ' +
                  err
              )
          );
        })
      );
  }
}
