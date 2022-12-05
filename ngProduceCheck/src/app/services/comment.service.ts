import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, catchError, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { Recipe } from '../models/recipe';
import { AuthService } from './auth.service';
import { RecipeService } from './recipe.service';
import { Comment } from '../models/comment';
@Injectable({
  providedIn: 'root'
})
export class CommentService {

  // private baseUrl = 'http://localhost:8088/api/recipes';
  private url = environment.baseUrl + 'api/recipes';

  constructor(
    private http: HttpClient,
    private auth: AuthService,
    private recipe: RecipeService
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
  show(recipeId: number): Observable<Comment[]>{
    return this.http.get<Comment[]>(this.url + '/' + recipeId + '/comments', this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(
          () =>
            new Error('CommentService.show():error retrieving comment : ' + err)
        );
      })
    );
  }

  create(recipeId: number, comment: Comment) {
    return this.http.post<Comment>(this.url + '/' + recipeId + '/comments' , comment, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(() => Error('CommentService.create(): error creating a new comment item'));
      }));
  }

  createReply(recipeId: number, commentId: number, comment: Comment) {
    return this.http.post<Comment>(this.url + '/' + recipeId + '/comments' + '/' + commentId, comment, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(() => Error('CommentService.create(): error creating a new comment item'));
      }));
  }

  destroy(recipeId: number, commentId: number) {
    return this.http.delete<void>(this.url + '/' + recipeId + '/comments/' + commentId, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(
          () => new Error('CommentService.destroy(): error de-activating comment: ' + err)
        );
      })
    );
  }
}
