% Marketing resource allocation (all data embedded)

int: cost_advertising = 3;
int: cost_promotion   = 2;
int: cost_sales       = 1;

int: max_advertising = 30000;
int: max_promotion   = 20000;
int: max_sales       = 25000;

int: min_adv_plus_promo = 10000;
int: max_2adv_plus_sales = 50000;
int: min_sales_minus_promo = 2000;

var 0..max_advertising: Advertising;
var 0..max_promotion:   Promotion;
var 0..max_sales:       Sales;

constraint Advertising + Promotion >= min_adv_plus_promo;
constraint 2 * Advertising + Sales <= max_2adv_plus_sales;
constraint Sales - Promotion >= min_sales_minus_promo;

var int: TotalCost = cost_advertising * Advertising
                   + cost_promotion   * Promotion
                   + cost_sales       * Sales;

solve minimize TotalCost;

output [
  "Advertising = ", show(Advertising), "\n",
  "Promotion   = ", show(Promotion), "\n",
  "Sales       = ", show(Sales), "\n",
  "TotalCost   = ", show(TotalCost), "\n"
];