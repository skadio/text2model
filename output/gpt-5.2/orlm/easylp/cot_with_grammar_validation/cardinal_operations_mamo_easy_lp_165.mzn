% Parameters
int: cost_advertising = 3;
int: cost_promotion   = 2;
int: cost_sales       = 1;

int: min_adv_plus_prom = 10000;
int: max_2adv_plus_sales = 50000;
int: min_sales_minus_prom = 2000;

int: max_advertising = 30000;
int: max_promotion   = 20000;
int: max_sales       = 25000;

% Variables
var 0..max_advertising: advertising;
var 0..max_promotion: promotion;
var 0..max_sales: sales;

var 0..(cost_advertising*max_advertising + cost_promotion*max_promotion + cost_sales*max_sales): total_cost;

% Constraints
constraint advertising + promotion >= min_adv_plus_prom;
constraint 2*advertising + sales <= max_2adv_plus_sales;
constraint sales - promotion >= min_sales_minus_prom;

constraint total_cost = cost_advertising*advertising + cost_promotion*promotion + cost_sales*sales;

% Objective
solve minimize total_cost;