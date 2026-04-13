% Parameters (with values embedded)
int: total_resource_cap = 5000;
int: min_effectiveness = 3000;
int: logistics_cap = 2500;

int: cost_X1 = 5;
int: cost_X2 = 3;
int: cost_X3 = 7;

% Variables
var 0..total_resource_cap: X1;
var 0..total_resource_cap: X2;
var 0..total_resource_cap: X3;

% Constraints
constraint X1 + X2 + X3 <= total_resource_cap;

constraint 4 * X1 + 6 * X3 >= min_effectiveness;

% "twice X2 + thrice the half of X3" -> 2*X2 + 3*(X3/2) <= 2500
% Avoid fractions: multiply by 2
constraint 4 * X2 + 3 * X3 <= 2 * logistics_cap;

% Objective
solve minimize cost_X1 * X1 + cost_X2 * X2 + cost_X3 * X3;