% Parameters
int: max_X1_X2 = 200;                % Upper bound on X1 + X2
int: max_X3_X4 = 150;                % Upper bound on X3 + X4

int: req_strength_12 = 1000;         % Minimum required strength for (X1,X2)
float: coeff_X1 = 5.0;               % Strength coefficient for X1
float: coeff_X2 = 10.0;              % Strength coefficient for X2

int: req_strength_34 = 750;          % Minimum required strength for (X3,X4)
float: coeff_X3 = 7.5;               % Strength coefficient for X3
float: coeff_X4 = 5.0;               % Strength coefficient for X4

int: cost_X1 = 5000;                 % Cost per unit of X1 (dollars)
int: cost_X2 = 7000;                 % Cost per unit of X2 (dollars)
int: cost_X3 = 10000;                % Cost per unit of X3 (dollars)
int: cost_X4 = 3000;                 % Cost per unit of X4 (dollars)

% Variables
var 0..max_X1_X2: X1;                % Number of units of type X1
var 0..max_X1_X2: X2;                % Number of units of type X2
var 0..max_X3_X4: X3;                % Number of units of type X3
var 0..max_X3_X4: X4;                % Number of units of type X4

var int: total_cost;                 % Total cost in dollars (to be minimized)
var float: strength_12;              % Strength for (X1,X2)
var float: strength_34;              % Strength for (X3,X4)

% Constraints
%--- Logistical capacity constraints (unit-count limits)
constraint X1 + X2 <= max_X1_X2;
constraint X3 + X4 <= max_X3_X4;

%--- Strength definition constraints (link strengths to unit decisions)
constraint strength_12 = coeff_X1 * int2float(X1) + coeff_X2 * int2float(X2);
constraint strength_34 = coeff_X3 * int2float(X3) + coeff_X4 * int2float(X4);

%--- Minimum required strategic strength constraints
constraint strength_12 >= int2float(req_strength_12);
constraint strength_34 >= int2float(req_strength_34);

%--- Total cost definition constraint
constraint total_cost = cost_X1*X1 + cost_X2*X2 + cost_X3*X3 + cost_X4*X4;

% Objective
solve minimize total_cost;

% Optional: show solution values (including the minimized cost)
output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), " X4=", show(X4), "\n",
  "strength_12=", show(strength_12), " strength_34=", show(strength_34), "\n",
  "total_cost=", show(total_cost), "\n"
];