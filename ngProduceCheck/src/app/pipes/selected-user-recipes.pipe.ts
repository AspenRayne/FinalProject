import { Pipe, PipeTransform } from '@angular/core';
import { Recipe } from '../models/recipe';
import { User } from '../models/user';
@Pipe({
  name: 'selectedUserRecipes'
})
export class SelectedUserRecipesPipe implements PipeTransform {

  transform(recipes: Recipe[], id: number): Recipe[] {
    let otherUserRec: Recipe[] = [];
    for(const recipe of recipes){
      if(recipe.user.id === id){
        otherUserRec.push(recipe);
      }
    }
    return otherUserRec;
  }

}
