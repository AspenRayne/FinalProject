import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomeComponent } from './components/home/home.component';
import { LoginComponent } from './components/login/login.component';
import { LogoutComponent } from './components/logout/logout.component';
import { NotFoundComponent } from './components/not-found/not-found.component';
import { RecipeComponent } from './components/recipe/recipe.component';
import { RegisterComponent } from './components/register/register.component';
import { AboutComponent } from './components/about/about.component';
import { CreateRecipeComponent } from './components/create-recipe/create-recipe.component';
import { UserComponent } from './components/user/user.component';
import { DatePipe } from '@angular/common';
import { RecipeSearchComponent } from './components/recipe-search/recipe-search.component';
import { IngredientComponent } from './components/ingredient/ingredient.component';
import { UserProfileComponent } from './components/user-profile/user-profile.component';
import { WelcomeComponent } from './components/welcome/welcome.component';

const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: 'home'},
  { path: 'home', component: HomeComponent },
  { path: 'login', component: LoginComponent },
  { path: 'about', component: AboutComponent },
  { path: 'logout', component: LogoutComponent},
  { path: 'register', component: RegisterComponent},
  { path: 'recipe', component: RecipeComponent},
  { path: 'recipe/:id', component: RecipeComponent},
  { path: 'profile/:id', component: UserProfileComponent},
  { path: 'recipe-search', component: RecipeSearchComponent },
  { path: 'create', component: CreateRecipeComponent },
  { path: 'ingredient', component: IngredientComponent },
  { path: 'ingredient/:recipe', component: IngredientComponent },
  { path: 'profile', component: UserComponent },
  { path: 'welcome', component: WelcomeComponent },
  { path: 'admin', component: UserComponent },
  { path: '**', component: NotFoundComponent},


];

@NgModule({
  imports: [DatePipe, RouterModule.forRoot(routes, {useHash: true})],
  exports: [RouterModule]
})
export class AppRoutingModule { }
