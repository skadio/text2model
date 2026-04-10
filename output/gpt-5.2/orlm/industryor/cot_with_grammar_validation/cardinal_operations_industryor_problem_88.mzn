% Parameters
int: profit_A = 30;
int: profit_B = 10;

int: max_hours = 40;
int: hours_per_kg_A = 6;
int: hours_per_kg_B = 3;

int: demand_multiplier_B_over_A = 3;

int: max_storage_A = 4;

int: ub_A = max_storage_A;
int: ub_B = max_hours div hours_per_kg_B;

% Variables
var 0..ub_A: xA;  % kg of product A produced/sold
var 0..ub_B: xB;  % kg of product B produced/sold

% Constraints
constraint
  hours_per_kg_A * xA + hours_per_kg_B * xB <= max_hours;

constraint
  xB >= demand_multiplier_B_over_A * xA;

constraint
  xA <= max_storage_A;

% Objective
solve maximize profit_A * xA + profit_B * xB;