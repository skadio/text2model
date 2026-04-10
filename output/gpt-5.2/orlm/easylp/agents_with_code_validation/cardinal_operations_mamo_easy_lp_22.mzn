% Parameters
int: cost_x = 50;                 % Cost per unit of product X
int: cost_y = 60;                 % Cost per unit of product Y

int: cap_limit = 500;             % Capacity limit for X + 2*Y
int: demand_min = 200;            % Minimum demand requirement for 3*X + Y
int: balance_limit = 100;         % Maximum allowed absolute difference |X - Y|

% Upper bounds derived from constraints for tighter variable domains
int: x_ub = cap_limit;            % From X + 2Y <= 500 and Y >= 0 => X <= 500
int: y_ub = cap_limit div 2;      % From X + 2Y <= 500 and X >= 0 => Y <= 250

% Variables
var 0..x_ub: x_units;             % Units of product X to produce (integer, nonnegative)
var 0..y_ub: y_units;             % Units of product Y to produce (integer, nonnegative)

var 0..(cost_x * x_ub + cost_y * y_ub): total_cost; % Total production cost (bounded)

% Constraints

%--- Link total cost to production decisions ---
constraint
  total_cost = cost_x * x_units + cost_y * y_units;

%--- Production capacity constraint: X + 2Y <= capacity limit ---
constraint
  x_units + 2 * y_units <= cap_limit;

%--- Minimum demand constraint: 3X + Y >= minimum demand ---
constraint
  3 * x_units + y_units >= demand_min;

%--- Inventory balance constraint: |X - Y| <= balance limit ---
constraint
  abs(x_units - y_units) <= balance_limit;

% Objective
solve minimize total_cost;