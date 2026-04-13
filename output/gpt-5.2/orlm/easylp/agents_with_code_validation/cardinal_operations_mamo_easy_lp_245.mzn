% Parameters
% Hour bounds for each team (given explicitly in the description)
int: x1_min = 0;
int: x1_max = 24;

int: x2_min = 0;
int: x2_max = 12;

int: x3_min = 0;
int: x3_max = 30;

% Cost per hour for each team
int: cost_x1 = 5;
int: cost_x2 = 6;
int: cost_x3 = 3;

% Operational constraint coefficients and RHS values
int: c1_a1 = 2;  int: c1_a2 = 3;  int: c1_a3 = 1;  int: c1_rhs = 10;  % >=
int: c2_a1 = 4;  int: c2_a2 = 5;  int: c2_a3 = 2;  int: c2_rhs = 20;  % <=
int: c3_a1 = 1;  int: c3_a2 = -2; int: c3_a3 = 1;  int: c3_rhs = 8;   % >=

% Total cost bounds
int: min_total_cost = 0;
int: max_total_cost = cost_x1 * x1_max + cost_x2 * x2_max + cost_x3 * x3_max;


% Variables
% Integer working hours for each team (whole-number hours)
var x1_min..x1_max: x1_hours;
var x2_min..x2_max: x2_hours;
var x3_min..x3_max: x3_hours;

% Total cost variable
var min_total_cost..max_total_cost: total_cost;


% Constraints
% --- Cost accounting: link total_cost to hours and per-hour costs ---
constraint
  total_cost = cost_x1 * x1_hours + cost_x2 * x2_hours + cost_x3 * x3_hours;

% --- Operational constraints: enforce required effort relationships ---
% Constraint 1: 2*x1 + 3*x2 + x3 >= 10
constraint
  c1_a1 * x1_hours + c1_a2 * x2_hours + c1_a3 * x3_hours >= c1_rhs;

% Constraint 2: 4*x1 + 5*x2 + 2*x3 <= 20
constraint
  c2_a1 * x1_hours + c2_a2 * x2_hours + c2_a3 * x3_hours <= c2_rhs;

% Constraint 3: x1 - 2*x2 + x3 >= 8
constraint
  c3_a1 * x1_hours + c3_a2 * x2_hours + c3_a3 * x3_hours >= c3_rhs;


% Objective
solve minimize total_cost;

output [
  "x1_hours=", show(x1_hours), "\n",
  "x2_hours=", show(x2_hours), "\n",
  "x3_hours=", show(x3_hours), "\n",
  "total_cost=", show(total_cost), "\n"
];