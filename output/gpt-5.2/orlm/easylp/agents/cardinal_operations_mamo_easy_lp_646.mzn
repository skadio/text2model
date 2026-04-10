% Parameters
int: cost_x1 = 10;      % Cost per unit allocated to X1
int: cost_x2 = 15;      % Cost per unit allocated to X2
int: cost_x3 = 20;      % Cost per unit allocated to X3
int: cost_x4 = 25;      % Cost per unit allocated to X4

int: min_x1_x2 = 200;     % Minimum combined allocation for X1 + X2
int: max_diff_x3_x4 = 50; % Maximum allowed absolute difference |X3 - X4|
int: rhs_ineq = 100;      % RHS for constraint: 2*X2 - X1 - 0.5*X3 <= 100
int: total_cap = 500;     % Total allocation upper bound across all units

int: lb_x1 = 0;  int: ub_x1 = 300; % Bounds for X1
int: lb_x2 = 0;  int: ub_x2 = 250; % Bounds for X2
int: lb_x3 = 0;  int: ub_x3 = 400; % Bounds for X3
int: lb_x4 = 0;  int: ub_x4 = 350; % Bounds for X4

int: ratio_num = 3;       % For (3/4)*X1 = X4 + 150
int: ratio_den = 4;
int: ratio_offset = 150;

% Variables
var lb_x1..ub_x1: x1;   % Allocation for unit X1 (integer)
var lb_x2..ub_x2: x2;   % Allocation for unit X2 (integer)
var lb_x3..ub_x3: x3;   % Allocation for unit X3 (integer)
var lb_x4..ub_x4: x4;   % Allocation for unit X4 (integer)

var 0..(cost_x1*ub_x1 + cost_x2*ub_x2 + cost_x3*ub_x3 + cost_x4*ub_x4): total_cost;
% Total cost to minimize (bounded linear expression)

% Constraints

% --- Total cost definition (linear expression) ---
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% --- Minimum combined allocation for X1 and X2 ---
constraint
  x1 + x2 >= min_x1_x2;

% --- Balance constraint between X3 and X4 (absolute difference limit) ---
constraint
  abs(x3 - x4) <= max_diff_x3_x4;

% --- Inequality: 2*X2 - X1 - 0.5*X3 <= rhs_ineq
% Avoid fractions by multiplying through by 2: 4*X2 - 2*X1 - X3 <= 2*rhs_ineq
constraint
  4 * x2 - 2 * x1 - x3 <= 2 * rhs_ineq;

% --- Ratio/equality: (ratio_num/ratio_den)*X1 = X4 + ratio_offset
% Avoid fractions: ratio_num * X1 = ratio_den * (X4 + ratio_offset)
constraint
  ratio_num * x1 = ratio_den * (x4 + ratio_offset);

% --- Total allocation capacity across all units ---
constraint
  x1 + x2 + x3 + x4 <= total_cap;

% Objective
solve minimize total_cost;