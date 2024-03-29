import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { User } from 'src/app/models/user';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-welcome',
  templateUrl: './welcome.component.html',
  styleUrls: ['./welcome.component.css']
})
export class WelcomeComponent implements OnInit {
  loginUser: User = new User();

  constructor(private auth: AuthService, private router: Router) { }

  ngOnInit(): void {
  }

  login(user: User): void {
    this.auth.login(user.username, user.password).subscribe({
      next: (loggedInUser) => {
        this.router.navigateByUrl('/home');
      },
      error: (problem) => {
        console.error('LoginComponent.login(): Error logging in user:');
        console.error(problem);
      },
    });
  }

}
