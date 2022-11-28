import { NumberSymbol } from '@angular/common';
import { Store } from './store';

export class Company {
  id: number;
  name: string;
  apiHostUrl: string;
  stores: Store[];

  constructor(
    id: number = 0,
    name: string = '',
    apiHostUrl: string = '',
    stores: Store[] = []
  ) {
    this.id = id;
    this.name = name;
    this.apiHostUrl = apiHostUrl;
    this.stores = stores;
  }
}
