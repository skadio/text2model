% Parameters
int: cost_X = 50;                 % Cost per unit of product X ($)
int: cost_Y = 60;                 % Cost per unit of product Y ($)

int: cap_total = 500;             % Capacity limit for X + 2Y
int: min_demand = 200;            % Minimum demand requirement for 3X + Y
int: max_diff = 100;              % Maximum allowed absolute difference |X - Y|


% Variables
var 0..cap_total: units_X;        % Units of product X (non-negative integer)
var 0..cap_total: units_Y;        % Units of product Y (non-negative integer)
var int: total_cost;              % Total production cost ($)


% Constraints
% Link total_cost to decision variables (linear cost definition)
constraint
  total_cost = cost_X * units_X + cost_Y * units_Y;

% Production capacity constraint: X + 2Y <= cap_total
constraint
  units_X + 2 * units_Y <= cap_total;

% Minimum demand constraint: 3X + Y >= min_demand
constraint
  3 * units_X + units_Y >= min_demand;

% Balanced inventory constraint: |X - Y| <= max_diff
constraint
  abs(units_X - units_Y) <= max_diff;


% Objective
solve minimize total_cost;