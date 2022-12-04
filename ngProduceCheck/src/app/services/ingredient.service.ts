import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, Observable, throwError } from 'rxjs';
import { CustomIngredientResponse } from '../models/custom-ingredient-response';
import { CustomIngredientStatistics } from '../models/custom-ingredient-statistics';
import { AuthService } from './auth.service';

@Injectable({
  providedIn: 'root',
})
export class IngredientService {
  private lookupUrl = 'http://localhost:8088/api/ingredientsLookup';
  private availabilityUrl = 'http://localhost:8088/api/availabilityLookup';

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

  searchIngredients(
    lookup: string,
    pagination: number,
    locationId: number
  ): Observable<CustomIngredientResponse> {
    return this.http
      .get<CustomIngredientResponse>(
        `${this.lookupUrl}/${lookup}/${pagination}/${locationId}`,
        this.getHttpOptions()
      )
      .pipe(
        catchError((err: any) => {
          console.log(err);
          return throwError(
            () =>
              new Error(
                'IngredientService.searchIngredients():error searching ingredients: ' +
                  err
              )
          );
        })
      );
  }

  availabilityLookup(
    storeId: number,
    upcNumbers: []
  ): Observable<CustomIngredientStatistics> {
    let data = { data: upcNumbers };
    return this.http
      .post<CustomIngredientStatistics>(
        `${this.availabilityUrl}/${storeId}`,
        data,
        this.getHttpOptions()
      )
      .pipe(
        catchError((err: any) => {
          console.log(err);
          return throwError(
            () =>
              new Error(
                'IngredientService.availabilityLookup():error searching availability for ingredients: ' +
                  err
              )
          );
        })
      );
  }
}
