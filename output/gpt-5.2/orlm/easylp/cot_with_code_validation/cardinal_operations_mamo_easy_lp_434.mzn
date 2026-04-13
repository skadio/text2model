% Parameters
int: total_investment = 20000;
int: cost_stock = 10;
int: cost_bond = 5;
int: min_weighted_value = 10000;
int: max_diff = 5000;

% Variables
var 0..total_investment: stocks;
var 0..total_investment: bonds;
var 0..(cost_stock*total_investment + cost_bond*total_investment): total_cost;

% Constraints
constraint stocks + bonds = total_investment;
constraint 3 * stocks + 2 * bonds >= min_weighted_value;
constraint abs(stocks - bonds) <= max_diff;

constraint total_cost = cost_stock * stocks + cost_bond * bonds;

% Objective
solve minimize total_cost;