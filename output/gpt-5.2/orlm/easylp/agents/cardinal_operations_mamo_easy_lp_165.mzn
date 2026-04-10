% Parameters
% Unit costs (dollars per unit)
int: cost_advertising = 3;
int: cost_promotion   = 2;
int: cost_sales       = 1;

% Requirement / limit constants (units)
int: min_adv_plus_promo      = 10000;
int: max_2adv_plus_sales     = 50000;
int: min_sales_minus_promo   = 2000;

% Upper bounds (units)
int: max_advertising = 30000;
int: max_promotion   = 20000;
int: max_sales       = 25000;

% Variables
% Resource allocations (whole number units)
var 0..max_advertising: advertising_units;
var 0..max_promotion:   promotion_units;
var 0..max_sales:       sales_units;

% Total cost (dollars), explicitly bounded
var 0..(cost_advertising*max_advertising
      + cost_promotion*max_promotion
      + cost_sales*max_sales): total_cost;

% Constraints
% Link total cost to the chosen allocations
constraint
  total_cost
  = cost_advertising * advertising_units
  + cost_promotion   * promotion_units
  + cost_sales       * sales_units;

% Minimum combined allocation for Advertising + Promotion
constraint
  advertising_units + promotion_units >= min_adv_plus_promo;

% Capacity / feasibility limit: 2*Advertising + Sales must not exceed maximum
constraint
  2 * advertising_units + sales_units <= max_2adv_plus_sales;

% Minimum difference constraint: Sales - Promotion must be at least required minimum
constraint
  sales_units - promotion_units >= min_sales_minus_promo;

% Objective
solve minimize total_cost;