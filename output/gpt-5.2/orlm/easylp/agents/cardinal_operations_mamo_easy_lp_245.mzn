% Parameters
% Hour bounds for each team (embedded data)
int: X1_min = 0;
int: X1_max = 24;
int: X2_min = 0;
int: X2_max = 12;
int: X3_min = 0;
int: X3_max = 30;

% Cost per hour for each team (embedded data)
int: cost_X1 = 5;
int: cost_X2 = 6;
int: cost_X3 = 3;

% Constraint coefficients / RHS values (embedded data)
int: c1_a1 = 2;  int: c1_a2 = 3;  int: c1_a3 = 1;  int: c1_rhs = 10; % >=
int: c2_a1 = 4;  int: c2_a2 = 5;  int: c2_a3 = 2;  int: c2_rhs = 20; % <=
int: c3_a1 = 1;  int: c3_a2 = -2; int: c3_a3 = 1;  int: c3_rhs = 8;  % >=


% Variables
% Integer working hours for each team
var X1_min..X1_max: X1_hours;
var X2_min..X2_max: X2_hours;
var X3_min..X3_max: X3_hours;

% Total cost (bounded using costs and hour bounds)
var 0..(cost_X1*X1_max + cost_X2*X2_max + cost_X3*X3_max): total_cost;


% Constraints
% Total cost definition (link cost variable to decision variables)
constraint total_cost = cost_X1*X1_hours + cost_X2*X2_hours + cost_X3*X3_hours;

% Operational constraint 1: 2*X1 + 3*X2 + 1*X3 >= 10
constraint c1_a1*X1_hours + c1_a2*X2_hours + c1_a3*X3_hours >= c1_rhs;

% Operational constraint 2: 4*X1 + 5*X2 + 2*X3 <= 20
constraint c2_a1*X1_hours + c2_a2*X2_hours + c2_a3*X3_hours <= c2_rhs;

% Operational constraint 3: 1*X1 - 2*X2 + 1*X3 >= 8
constraint c3_a1*X1_hours + c3_a2*X2_hours + c3_a3*X3_hours >= c3_rhs;


% Objective
solve minimize total_cost;

% Optional output for inspection
output [
  "X1_hours=", show(X1_hours), "\n",
  "X2_hours=", show(X2_hours), "\n",
  "X3_hours=", show(X3_hours), "\n",
  "total_cost=", show(total_cost), "\n"
];