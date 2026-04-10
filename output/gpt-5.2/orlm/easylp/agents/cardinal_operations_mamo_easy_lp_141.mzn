% Parameters
int: min_units = 10;                 % Minimum total number of units deployed
int: max_firepower = 50;             % Maximum allowed combined firepower
int: firepower_X = 5;                % Firepower contribution per unit of X
int: firepower_Y = 3;                % Firepower contribution per unit of Y
int: cost_X = 1000;                  % Support points cost per unit of X
int: cost_Y = 2000;                  % Support points cost per unit of Y

% Variables
var 0..max_firepower div firepower_X: x;  % Number of units of type X (bounded by firepower limit)
var 0..max_firepower div firepower_Y: y;  % Number of units of type Y (bounded by firepower limit)
var 0..(cost_X*(max_firepower div firepower_X) + cost_Y*(max_firepower div firepower_Y)): total_cost;
  % Total support points (bounded by max possible within variable domains)

% Constraints
% Strategic requirement: deploy at least the minimum number of total units
constraint x + y >= min_units;

% Rules of engagement: combined firepower must not exceed the allowed maximum
constraint firepower_X * x + firepower_Y * y <= max_firepower;

% Accounting: total support points cost equals the sum of per-unit costs
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;