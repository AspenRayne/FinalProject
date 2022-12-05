import { DatePipe } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, Observable, throwError } from 'rxjs';
import { environment } from 'src/environments/environment.prod';
import { User } from '../models/user';
import { AuthService } from './auth.service';

@Injectable({
  providedIn: 'root'
})
export class UserService {

  // private baseUrl = 'http://localhost:8088/api/users';
  private baseUrl = environment.baseUrl + 'api/users';


  constructor(
    private http: HttpClient,
    // private datePipe: DatePipe,
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
  index() {
    return this.http.get<User[]>(this.baseUrl, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(
          () =>
            new Error('UserService.index():error retrieving Users: ' + err)
        );
      })
    );
  }
  show(userId: number): Observable<User>{
    return this.http.get<User>(this.baseUrl + '/' + userId, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(
          () =>
            new Error('UserService.show():error retrieving User : ' + err)
        );
      })
    );
  }
  update(user: User) {
    return this.http.put<User>(this.baseUrl + '/' + user.id, user, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(
          () => new Error('UserService.update():error updating User: ' + err)
        );
      })
    );
  }

  destroy(id: number) {
    return this.http.delete<void>(this.baseUrl + '/' + id, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(
          () => new Error('UserService.destroy(): error de-activating User: ' + err)
        );
      })
    );
  }
}


