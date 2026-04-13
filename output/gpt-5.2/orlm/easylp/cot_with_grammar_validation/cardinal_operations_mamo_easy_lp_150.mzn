% Parameters
int: capacity_tons = 30;
int: weight_X = 2;
int: weight_Y = 3;

int: contract_X_units = 4;
int: contract_Y_units = 1;
int: contract_min_tons = 10;

int: cost_X = 5;
int: cost_Y = 7;

% Variables
var 0..(capacity_tons div weight_X): x_units;
var 0..(capacity_tons div weight_Y): y_units;
var 0..(cost_X*(capacity_tons div weight_X) + cost_Y*(capacity_tons div weight_Y)): total_cost;

% Constraints
constraint weight_X * x_units + weight_Y * y_units <= capacity_tons;

constraint (contract_X_units * weight_X) * x_units + (contract_Y_units * weight_Y) * y_units >= contract_min_tons;

constraint total_cost = cost_X * x_units + cost_Y * y_units;

% Objective
solve minimize total_cost;