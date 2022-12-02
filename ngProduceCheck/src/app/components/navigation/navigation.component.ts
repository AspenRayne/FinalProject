import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs/internal/Observable';
import { User } from 'src/app/models/user';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-navigation',
  templateUrl: './navigation.component.html',
  styleUrls: ['./navigation.component.css']
})
export class NavigationComponent implements OnInit {
  public isCollasped = false;
  public loggedInUser: User | null = null;
  constructor(
    private auth: AuthService) {}

  ngOnInit(): void {
    this.getCurrentUser();
  }

  checkLogin(): boolean {
    return this.auth.checkLogin();
  }

  getCurrentUser(): void {
     this.auth.getLoggedInUser().subscribe(
      {
        next: (data) => {
          this.loggedInUser= data;
          console.log(this.loggedInUser);

          // this.editUser = null;
          // this.reload();
        },
        error: (err) => {
          console.error('NavigationComponent.getCurrentUser(): Error retrieving Logged In User');
          console.error(err);

        }
      });


    }
    isAdmin(): boolean {
        if(this.checkLogin()){
          if(this.loggedInUser?.role === 'ADMIN'){
            return true;
          }
        }
        return false;
    }
  }
