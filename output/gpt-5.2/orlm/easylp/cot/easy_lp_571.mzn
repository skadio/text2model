% Parameters (with values embedded)
int: demand_X = 500;
int: demand_Y = 400;
int: demand_Z = 700;
int: total_budget = 1000;

int: min_diff_2X_minus_Y = 200;
int: min_diff_Z_minus_Y = 50;

% Variables
var 0..total_budget: x;
var 0..total_budget: y;
var 0..total_budget: z;

% Constraints
constraint x <= demand_X;
constraint y <= demand_Y;
constraint z <= demand_Z;

constraint x + y + z <= total_budget;
constraint 2 * x - y >= min_diff_2X_minus_Y;
constraint z - y >= min_diff_Z_minus_Y;

% Objective
solve minimize x + y + z;