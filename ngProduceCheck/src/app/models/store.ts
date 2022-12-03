import { Company } from './company';
import { User } from './user';

export class Store {
  id: number;
  street1: string;
  street2: string;
  city: string;
  state: string;
  zipcode: string;
  users: User[];
  company: Company;
  locationId: number;

  constructor(
    id: number = 0,
    street1: string = '',
    street2: string = '',
    city: string = '',
    state: string = '',
    zipcode: string = '',
    users: User[] = [],
    company: Company = new Company,
    locationId: number = 0
  ) {
    this.id = id;
    this.street1 = street1;
    this.street2 = street2;
    this.city = city;
    this.state = state;
    this.zipcode = zipcode;
    this.users = users;
    this.company = company;
    this.locationId = locationId;
  }
}
