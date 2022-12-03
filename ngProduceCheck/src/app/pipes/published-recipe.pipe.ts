import { Pipe, PipeTransform } from '@angular/core';
import { Recipe } from '../models/recipe';

@Pipe({
  name: 'publishedRecipe'
})
export class PublishedRecipePipe implements PipeTransform {

  transform(recipes: Recipe[] ): Recipe[]{
    let published: Recipe[] = [];
    for (const recipe of recipes) {
      if(recipe.published){
        published.push(recipe);
      }

    }
    return published;
  }

}
