% Parameters (with values embedded)
int: max_total_tours = 500;
int: diversity_requirement = 1000;
int: balance_limit = 200;
int: cost_X = 50;
int: cost_Y = 30;

% Variables
var 0..max_total_tours: X;
var 0..max_total_tours: Y;
var 0..(cost_X*max_total_tours + cost_Y*max_total_tours): total_cost;

% Constraints
constraint X + Y <= max_total_tours;
constraint 3*X + 2*Y >= diversity_requirement;
constraint abs(X - Y) <= balance_limit;
constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;