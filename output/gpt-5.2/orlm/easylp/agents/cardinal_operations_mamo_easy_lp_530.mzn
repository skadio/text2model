% Parameters
% Cost per unit for each project
int: cost_x1 = 10;
int: cost_x2 = 15;
int: cost_x3 = 20;

% Constraint coefficients and right-hand sides
int: a11 = 5;   int: a12 = 7;   int: a13 = 9;    int: rhs1 = 5000;  % 5*x1 + 7*x2 + 9*x3 >= 5000
int: rhs2 = 1500;                                    % 3*x2 - x1 - 4*x3 <= 1500
int: rhs3 = 2000;                                    % x1 - 2.5*x2 - x3 == 2000

% Variable bounds
int: x1_lb = 0;     int: x1_ub = 10000;
int: x2_lb = 0;     int: x2_ub = 8000;
int: x3_lb = 0;     int: x3_ub = 6000;


% Variables
var x1_lb..x1_ub: x1;  % Units allocated to Project X1
var x2_lb..x2_ub: x2;  % Units allocated to Project X2
var x3_lb..x3_ub: x3;  % Units allocated to Project X3

var int: total_cost;   % Total cost to minimize (in dollars)


% Constraints
% -------------------------
% Total cost definition
% -------------------------
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% -------------------------
% Minimum effectiveness requirement
% 5*x1 + 7*x2 + 9*x3 >= 5000
% -------------------------
constraint
  a11 * x1 + a12 * x2 + a13 * x3 >= rhs1;

% -------------------------
% Budgetary/relationship upper-bound constraint
% 3*x2 - x1 - 4*x3 <= 1500
% -------------------------
constraint
  3 * x2 - x1 - 4 * x3 <= rhs2;

% -------------------------
% Exact difference constraint with fractional coefficient
% x1 - 2.5*x2 - x3 == 2000
% Implemented without floats by multiplying through by 2:
% 2*x1 - 5*x2 - 2*x3 == 4000
% -------------------------
constraint
  2 * x1 - 5 * x2 - 2 * x3 = 2 * rhs3;


% Objective
solve minimize total_cost;