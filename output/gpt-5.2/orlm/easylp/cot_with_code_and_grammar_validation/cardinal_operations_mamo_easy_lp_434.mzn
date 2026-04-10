% Parameters
int: total_budget = 20000;
int: stock_unit_cost = 10;
int: bond_unit_cost = 5;

int: min_weighted_value = 10000;   % 3*stocks + 2*bonds >= 10000
int: max_diff = 5000;              % |stocks - bonds| <= 5000

% Variables
var 0..(total_budget div stock_unit_cost): stocks;
var 0..(total_budget div bond_unit_cost): bonds;

var 0..total_budget: total_cost;

% Constraints
constraint total_cost = stock_unit_cost * stocks + bond_unit_cost * bonds;

constraint total_cost <= total_budget;

constraint 3 * stocks + 2 * bonds >= min_weighted_value;

constraint abs(stocks - bonds) <= max_diff;

% Objective
solve minimize total_cost;