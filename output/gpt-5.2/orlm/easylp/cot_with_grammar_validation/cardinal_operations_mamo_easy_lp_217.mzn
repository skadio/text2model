% Parameters
int: total_budget_cap = 5000;
int: cost_X = 10;
int: cost_Y = 20;
int: cost_Z = 30;

int: eff_req = 10000;
int: eff_X_units = 5;
int: eff_Y_units = 10;

int: diff_XZ_cap = 1500;

% Variables
var 0..total_budget_cap: x;
var 0..total_budget_cap: y;
var 0..total_budget_cap: z;

var 0..(cost_X*total_budget_cap + cost_Y*total_budget_cap + cost_Z*total_budget_cap): total_cost;

% Constraints
constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;

constraint x + y + z <= total_budget_cap;

constraint eff_X_units * x + eff_Y_units * y >= eff_req;

constraint abs(x - z) <= diff_XZ_cap;

% Objective
solve minimize total_cost;