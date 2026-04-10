% Parameters
float: profit_regular = 2.50;      % profit per regular taco
float: profit_deluxe  = 3.55;      % profit per deluxe taco

int: max_demand_regular = 50;      % maximum demand for regular tacos
int: max_demand_deluxe  = 40;      % maximum demand for deluxe tacos
int: max_total_tacos    = 70;      % maximum total tacos (supply limit)

% Variables
var 0..max_demand_regular: x1;     % number of regular tacos to make
var 0..max_demand_deluxe:  x2;     % number of deluxe tacos to make

% Constraints
% Demand limits (already enforced by variable domains, repeated here for clarity)
constraint x1 <= max_demand_regular;
constraint x2 <= max_demand_deluxe;

% Supply limit: total number of tacos cannot exceed available supplies
constraint x1 + x2 <= max_total_tacos;

% Objective
solve maximize profit_regular * x1 + profit_deluxe * x2;