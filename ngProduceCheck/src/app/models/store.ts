export class Store {
  id: number;
  street1: string;
  street2: string;
  city: string;
  state: string;
  zipcode: string;

  constructor(
    id: number = 0,
    street1: string = '',
    street2: string = '',
    city: string = '',
    state: string = '',
    zipcode: string = ''
  ) {
    this.id = id;
    this.street1 = street1;
    this.street2 = street2;
    this.city = city;
    this.state = state;
    this.zipcode = zipcode;
  }
}
