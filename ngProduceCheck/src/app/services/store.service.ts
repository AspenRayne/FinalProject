import { HttpClient } from '@angular/common/http';
import { Injectable, NO_ERRORS_SCHEMA } from '@angular/core';
import { catchError, Observable, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { Store } from '../models/store';
import { User } from '../models/user';
import { AuthService } from './auth.service';

@Injectable({
  providedIn: 'root'
})
export class StoreService {

  // private baseUrl = 'http://localhost:8088/api/favoriteStore'
  // private searchUrl = 'http://localhost:8088/api/stores';
  // private indexUrl = 'http://localhost:8088/api/favoriteStores'
  private baseUrl = environment.baseUrl + 'api/favoriteStore';
  private searchUrl = environment.baseUrl + 'api/stores';
  private indexUrl = environment.baseUrl + 'api/favoriteStores';

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

  getStoreLocations(zipcode: String): Observable<Store[]>{
    return this.http.get<Store[]>(`${this.searchUrl}/${zipcode}`, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(
          () =>
          new Error('StoreService.getStoreLocations():error searching stores: ' + err)
        );
      })
    )
  }

  getUserStores(): Observable<Store[]>{
    return this.http.get<Store[]>(`${this.indexUrl}`, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(
          () =>
          new Error('StoreService.getUserStores():error retrieving stores: ' + err)
        );
      })
    )
  }

  setFavoriteStore(store: Store): Observable<Store>{
    return this.http.post<Store>(this.baseUrl, store, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(
          () =>
          new Error('StoreService.setFavoriteStore():error saving store: ' + err)
        );
      })
    )
  }

  unsaveStore(id:number) {
    return this.http.delete<void>(`${this.baseUrl}/${id}`, this.getHttpOptions()).pipe(
      catchError((err: any) => {
        console.log(err);
        return throwError(
          () =>
          new Error('StoreService.unsaveStore():error unsaving store: ' + err)
        );
      })
    )
  }

}
