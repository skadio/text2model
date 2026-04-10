% Parameters (with values embedded)
int: total_investment = 20000;
int: cost_stock = 10;
int: cost_bond  = 5;

int: min_weighted_value = 10000;   % 3*stocks + 2*bonds >= 10000
int: max_difference = 5000;        % |stocks - bonds| <= 5000

% Variables
var 0..(total_investment div cost_stock): stocks;
var 0..(total_investment div cost_bond):  bonds;

% Constraints
constraint cost_stock * stocks + cost_bond * bonds = total_investment;

constraint 3 * stocks + 2 * bonds >= min_weighted_value;

constraint abs(stocks - bonds) <= max_difference;

% Objective
solve minimize (cost_stock * stocks + cost_bond * bonds);