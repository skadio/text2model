% Parameters
% Unit production costs (in dollars)
int: cost_x = 5;
int: cost_y = 10;

% Resource/labor constraint coefficients and bounds:
% 2*x + 3*y <= 100
int: a1_x = 2;
int: a1_y = 3;
int: rhs1 = 100;

% Demand constraint coefficients and bounds:
% 4*x + 1*y >= 50
int: a2_x = 4;
int: a2_y = 1;
int: rhs2 = 50;

% Variables
% Number of units produced (whole numbers, nonnegative)
var 0..100: x_units;  % Product X units
var 0..100: y_units;  % Product Y units

% Total production cost (bounded for linear expressions)
var 0..(cost_x*100 + cost_y*100): total_cost;

% Constraints
% Link total production cost to decision variables
constraint
  total_cost = cost_x * x_units + cost_y * y_units;

% Resource/labor availability constraint: 2*x + 3*y <= 100
constraint
  a1_x * x_units + a1_y * y_units <= rhs1;

% Market demand constraint: 4*x + 1*y >= 50
constraint
  a2_x * x_units + a2_y * y_units >= rhs2;

% Objective
solve minimize total_cost;