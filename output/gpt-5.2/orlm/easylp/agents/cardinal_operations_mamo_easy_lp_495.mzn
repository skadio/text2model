% Parameters
int: max_weight = 500;                 % Upper bound for 2*X + 3*Y (weight restriction)
int: min_trucks = 100;                 % Lower bound for X + Y (demand requirement)
int: max_diff = 50;                    % Upper bound for |X - Y| (balance requirement)
int: cost_x = 4;                       % Cost per truck on route X
int: cost_y = 6;                       % Cost per truck on route Y

% Variables
var 0..max_weight: trucks_x;           % Number of trucks assigned to route X (integer, non-negative)
var 0..max_weight: trucks_y;           % Number of trucks assigned to route Y (integer, non-negative)
var 0..(cost_x*max_weight + cost_y*max_weight): total_cost;  % Total transportation cost

% Constraints
% Weight restriction: 2*X + 3*Y must not exceed the maximum allowed weight
constraint
  2 * trucks_x + 3 * trucks_y <= max_weight;

% Demand requirement: total number of trucks across both routes must be at least the minimum
constraint
  trucks_x + trucks_y >= min_trucks;

% Balance requirement: difference in number of trucks between routes must be within max_diff
constraint
  abs(trucks_x - trucks_y) <= max_diff;

% Total cost definition: link total_cost to the number of trucks on each route
constraint
  total_cost = cost_x * trucks_x + cost_y * trucks_y;

% Objective
solve minimize total_cost;