% Parameters (with values embedded)
int: cost_X = 50;
int: cost_Y = 30;
int: cost_Z = 20;

int: max_total_units = 500;

int: rhs_demand = 100;      % 3*X - Y + Z >= 100
int: rhs_logistics = 200;   % X - 2*Y - Z <= 200

% Variables
var 0..max_total_units: X;
var 0..max_total_units: Y;
var 0..max_total_units: Z;

var 0..(cost_X*max_total_units + cost_Y*max_total_units + cost_Z*max_total_units): total_cost;

% Constraints
constraint X + Y + Z <= max_total_units;
constraint 3*X - Y + Z >= rhs_demand;
constraint X - 2*Y - Z <= rhs_logistics;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];