import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { User } from 'src/app/models/user';
import { AuthService } from 'src/app/services/auth.service';
import { UserService } from 'src/app/services/user.service';

@Component({
  selector: 'app-user',
  templateUrl: './user.component.html',
  styleUrls: ['./user.component.css']
})
export class UserComponent implements OnInit {


  user: User | null = null;
  selected: User | null = null;
  users: User[] = [];
  editUser: User | null = null;

  constructor(
    private auth: AuthService,
    private userService: UserService,
    private route: ActivatedRoute,
    private router: Router
  ) { }

  ngOnInit(): void {
    let routeId = this.route.snapshot.paramMap.get('id');
    console.log(routeId);
    if(routeId && !this.selected){
      let userId = Number.parseInt(routeId);
      if(isNaN(userId)){
        this.router.navigateByUrl('invalidId');
      }else{
        this.userService.show(userId).subscribe({
          next: (user) => {
            this.selected = user;
          },
          error: (fail) => {
            console.error('UserService.ngOnInit: User not found')
            this.router.navigateByUrl('userNotFound');

          }
        })
      }
    }

    this.reload();
    this.auth.getLoggedInUser().subscribe(
      {
        next: (data) => {
          this.user = data
        },
        error: (err) => {
          console.error("UserComponent.reload(): error loading Users");
          console.error(err);

        }
      });


  }

  reload(){
    this.userService.index().subscribe(
      {
      next: (data) => {
        this.users = data
      },
      error: (err) => {
        console.error("UserComponent.reload(): error loading Users");
        console.error(err);

      }
    })
  }

  displayUser(user: User){
    this.selected = user;
  }

  updateUser(updatedUser: User){
    this.userService.update(updatedUser).subscribe(
      {
        next: (data) => {
          this.selected = data;
          this.editUser = null;
          this.reload();
        },
        error: (err) => {
          console.error('UserComponent.updateUser(): Error updating User');
          console.error(err);

        }
    });
  }
  deleteUser(id: number){
    this.userService.destroy(id).subscribe(
      {
        next: () => {
          this.reload();
        },
        error: (err) => {
          console.error('UserComponent.deleteUser(): Error de-activating User');
          console.error(err);


        }
    });
  }
}
