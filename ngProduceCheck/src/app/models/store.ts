import { User } from './user';

export class Store {
  id: number;
  street1: string;
  street2: string;
  city: string;
  state: string;
  zipcode: string;
  users: User[];

  constructor(
    id: number = 0,
    street1: string = '',
    street2: string = '',
    city: string = '',
    state: string = '',
    zipcode: string = '',
    users: User[] = []
  ) {
    this.id = id;
    this.street1 = street1;
    this.street2 = street2;
    this.city = city;
    this.state = state;
    this.zipcode = zipcode;
    this.users = users;
  }
}
