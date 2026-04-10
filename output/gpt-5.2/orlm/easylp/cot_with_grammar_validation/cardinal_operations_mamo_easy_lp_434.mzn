% Parameters
int: total_investment = 20000;
int: stock_unit_cost = 10;
int: bond_unit_cost  = 5;

int: min_weighted_value = 10000; % 3*stocks + 2*bonds >= 10000
int: max_difference = 5000;      % |stocks - bonds| <= 5000

% Variables
var 0..total_investment: stocks;
var 0..total_investment: bonds;
var 0..(stock_unit_cost*total_investment + bond_unit_cost*total_investment): total_cost;

% Constraints
constraint stocks + bonds = total_investment;

constraint 3 * stocks + 2 * bonds >= min_weighted_value;

constraint abs(stocks - bonds) <= max_difference;

constraint total_cost = stock_unit_cost * stocks + bond_unit_cost * bonds;

% Objective
solve minimize total_cost;