import { HttpClient, HttpClientModule } from '@angular/common/http';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { NavigationComponent } from './components/navigation/navigation.component';
import { HomeComponent } from './components/home/home.component';
import { FooterComponent } from './components/footer/footer.component';
import { RegisterComponent } from './components/register/register.component';
import { LoginComponent } from './components/login/login.component';
import { RecipeComponent } from './components/recipe/recipe.component';
import { LogoutComponent } from './components/logout/logout.component';
import { NotFoundComponent } from './components/not-found/not-found.component';
import { UserComponent } from './components/user/user.component';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { AboutComponent } from './components/about/about.component';
import { CreateRecipeComponent } from './components/create-recipe/create-recipe.component';
import { PublishedRecipePipe } from './pipes/published-recipe.pipe';

@NgModule({
  declarations: [
    AppComponent,
    NavigationComponent,
    HomeComponent,
    FooterComponent,
    RegisterComponent,
    LoginComponent,
    RecipeComponent,
    LogoutComponent,
    NotFoundComponent,
    UserComponent,
    AboutComponent,
    CreateRecipeComponent,
    PublishedRecipePipe
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    FormsModule,
    NgbModule
  ],
  providers: [PublishedRecipePipe],
  bootstrap: [AppComponent]
})
export class AppModule { }
