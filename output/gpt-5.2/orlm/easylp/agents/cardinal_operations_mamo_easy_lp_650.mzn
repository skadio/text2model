% Parameters
% Cost per ship type (units per ship)
int: cost_x1 = 50;
int: cost_x2 = 60;
int: cost_x3 = 70;
int: cost_x4 = 80;

% Capacity/limit parameters
int: max_x1_x2 = 1000;   % docking space limit for x1 + x2
int: max_x3_x4 = 1500;   % crew availability limit for x3 + x4
int: x2_margin = 400;    % margin used in the x4 vs x2 operational constraint

% Variables
% Decision variables: numbers of ships (must be integers)
var 0..max_x1_x2: x1;
var 0..max_x1_x2: x2;
var 0..max_x3_x4: x3;
var 0..max_x3_x4: x4;

% Total cost (upper bound based on maximum possible in each group)
int: total_cost_ub =
  cost_x1 * max_x1_x2 + cost_x2 * max_x1_x2 +
  cost_x3 * max_x3_x4 + cost_x4 * max_x3_x4;
var 0..total_cost_ub: total_cost;

% Constraints
% Capacity limits (docking space and crew availability)
constraint x1 + x2 <= max_x1_x2;
constraint x3 + x4 <= max_x3_x4;

% Balance constraint:
% "x1 must be at least twice that of half the number of x3" => x1 >= x3
constraint x1 >= x3;

% Operational efficiency constraint:
% "no more than half the number of x4 can be added without exceeding x2 by 400"
% Interpreted as: x4/2 <= x2 + x2_margin  <=>  x4 <= 2*x2 + 2*x2_margin
constraint x4 <= 2 * x2 + 2 * x2_margin;

% Define total operating cost from decision variables and per-unit costs
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];