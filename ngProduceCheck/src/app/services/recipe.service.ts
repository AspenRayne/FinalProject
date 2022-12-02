import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, throwError, Observable } from 'rxjs';
import { Recipe } from '../models/recipe';
import { AuthService } from './auth.service';

@Injectable({
  providedIn: 'root'
})
export class RecipeService {

  private baseUrl = 'http://localhost:8088/api/recipes';
  private indexUrl = 'http://localhost:8088/api/allrecipes';
  private searchUrl = 'http://localhost:8088/api/recipes/search'

  constructor(
    private http: HttpClient,
    private auth: AuthService
  ) { }

  getHttpOptions(){
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
    return this.http.post<Recipe>(this.baseUrl, recipe, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(() => Error('RecipeService.create(): error creating a new recipe item'));
      }));
  }
  show(recipeId: number): Observable<Recipe>{
    return this.http.get<Recipe>(this.baseUrl + '/' + recipeId, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(
          () =>
            new Error('RecipeService.show():error retrieving recipe : ' + err)
        );
      })
    );
  }
  update(recipe: Recipe) {
    return this.http.put<Recipe>(this.baseUrl + '/' + recipe.id, recipe, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(
          () => new Error('RecipeService.update():error updating recipe: ' + err)
        );
      })
    );
  }
  search(keyword: string): Observable<Recipe[]> {
    return this.http.get<Recipe[]>(this.searchUrl + '/' + keyword, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(
          () =>
            new Error('RecipeService.index():error retrieving recipes: ' + err)
        );
      })
    );
  }
  destroy(id: number) {
    return this.http.delete<void>(this.baseUrl + '/' + id, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(
          () => new Error('RecipeService.destroy(): error de-activating recipe: ' + err)
        );
      })
    );
  }
}
