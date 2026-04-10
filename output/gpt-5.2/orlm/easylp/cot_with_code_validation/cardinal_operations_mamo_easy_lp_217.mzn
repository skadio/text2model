% Parameters
int: total_budget_cap = 5000;
int: cost_X = 10;
int: cost_Y = 20;
int: cost_Z = 30;

int: eff_req = 10000;
int: eff_X_coeff = 5;
int: eff_Y_coeff = 10;

int: diff_XZ_cap = 1500;

% Variables
var 0..total_budget_cap: X;
var 0..total_budget_cap: Y;
var 0..total_budget_cap: Z;

var 0..(cost_X*total_budget_cap + cost_Y*total_budget_cap + cost_Z*total_budget_cap): total_cost;

% Constraints
constraint X + Y + Z <= total_budget_cap;

constraint eff_X_coeff * X + eff_Y_coeff * Y >= eff_req;

constraint abs(X - Z) <= diff_XZ_cap;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;