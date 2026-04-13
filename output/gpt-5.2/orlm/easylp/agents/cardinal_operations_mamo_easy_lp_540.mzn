% Parameters
% Unit costs ($ per unit resource) for projects X1, X2, X3
int: cost_x1 = 500;
int: cost_x2 = 700;
int: cost_x3 = 900;

% Resource allocation limits and constraint coefficients
int: max_total_alloc = 10;

int: c1_x1 = 5;
int: c1_x2 = 4;
int: c1_rhs_min = 30;

int: c2_x1 = 7;
int: c2_x3 = 6;
int: c2_rhs_max = 20;


% Variables
% Whole-number resource allocations to each project (non-negative integers)
var 0..max_total_alloc: x1;
var 0..max_total_alloc: x2;
var 0..max_total_alloc: x3;

% Total cost in dollars (bounded using max_total_alloc and maximum unit cost)
var 0..(max_total_alloc * max([cost_x1, cost_x2, cost_x3])): total_cost;


% Constraints
% Total resource allocation limit across all projects
constraint x1 + x2 + x3 <= max_total_alloc;

% Minimum combined weighted allocation requirement (budget/manpower condition)
constraint c1_x1 * x1 + c1_x2 * x2 >= c1_rhs_min;

% Upper bound on the weighted difference between X1 and X3 allocations
constraint c2_x1 * x1 - c2_x3 * x3 <= c2_rhs_max;

% X2 must be at least X1 + X3
constraint x2 - (x1 + x3) >= 0;

% Define total cost from unit costs and allocations
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;


% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), "\n",
  "total_cost=", show(total_cost), "\n"
];