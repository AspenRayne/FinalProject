export class CustomIngredientStatistics {
  salePrice: number;
  price: number;
  inStore: boolean;
  upc: string;
  availability: string;

  constructor(
    salePrice: number = 0,
    price: number = 0,
    inStore: boolean = false,
    upc: string = '',
    availability: string = ''
  ) {
    this.salePrice = salePrice;
    this.price = price;
    this.inStore = inStore;
    this.upc = upc;
    this.availability = availability;
  }
}
// export class CustomIngredientStatistics {
//   statMap: Map<String, IngredientStatistics>;

//   constructor(statMap: Map<string, IngredientStatistics> = new Map) {
//     this.statMap = statMap;
//   }
// }
