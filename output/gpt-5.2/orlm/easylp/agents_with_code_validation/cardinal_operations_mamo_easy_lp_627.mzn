% Parameters
int: cost_x1 = 5000;            % Cost per employee in department X1
int: cost_x2 = 4000;            % Cost per employee in department X2
int: cost_x3 = 6000;            % Cost per employee in department X3
int: cost_x4 = 7000;            % Cost per employee in department X4

int: max_x1 = 30;               % Maximum staff capacity for X1
int: max_x2 = 40;               % Maximum staff capacity for X2
int: max_x3 = 50;               % Maximum staff capacity for X3
int: max_x4 = 60;               % Maximum staff capacity for X4

int: min_x1_x2 = 10;            % Minimum combined staff in X1 and X2
int: max_x3_x4 = 20;            % Maximum combined staff in X3 and X4
int: min_expr1 = 5;             % Minimum for (2*X2 - X1 - X3)
int: min_expr2 = 5;             % Minimum for (X4 - X1 - X2)

% Variables
var 0..max_x1: x1;              % Number of employees assigned to department X1
var 0..max_x2: x2;              % Number of employees assigned to department X2
var 0..max_x3: x3;              % Number of employees assigned to department X3
var 0..max_x4: x4;              % Number of employees assigned to department X4

var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3 + cost_x4*max_x4): total_cost;
                                % Total staffing cost (bounded by max capacities)

% Constraints
% Link total_cost to staffing decision variables
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Minimum combined staffing requirement for departments X1 and X2
constraint
  x1 + x2 >= min_x1_x2;

% Maximum combined staffing limit for departments X3 and X4
constraint
  x3 + x4 <= max_x3_x4;

% Expression constraint: (2*X2 - X1 - X3) must be at least min_expr1
constraint
  2 * x2 - x1 - x3 >= min_expr1;

% Expression constraint: (X4 - X1 - X2) must be at least min_expr2
constraint
  x4 - x1 - x2 >= min_expr2;

% Objective
solve minimize total_cost;

% Optional output for inspection
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];