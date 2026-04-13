% Parameters
int: max_total_groups = 20;        % Weekly capacity limit for total number of groups
int: min_mix_requirement = 10;     % Minimum required value for (2*X + Y)
int: max_diff = 5;                % Maximum allowed absolute difference |X - Y|
int: max_X = 15;                  % Maximum tours of type X per week
int: max_Y = 10;                  % Maximum tours of type Y per week
int: cost_X = 100;                % Cost per tour of type X (dollars)
int: cost_Y = 50;                 % Cost per tour of type Y (dollars)

% Variables
var 0..max_X: x;                  % Number of tours for group type X (integer)
var 0..max_Y: y;                  % Number of tours for group type Y (integer)
var 0..(cost_X*max_X + cost_Y*max_Y): total_cost;  % Total weekly cost (dollars)

% Constraints
% Link total_cost to the number of tours of each type
constraint total_cost = cost_X * x + cost_Y * y;

% Weekly capacity limit on total number of groups
constraint x + y <= max_total_groups;

% Diversity / mix requirement: 2*X + Y must be at least the minimum
constraint 2 * x + y >= min_mix_requirement;

% Balance requirement: absolute difference between X and Y is bounded
constraint abs(x - y) <= max_diff;

% Objective
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];