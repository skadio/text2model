% Parameters
% Cost coefficients (embedded from problem statement)
float: c1 = 0.5;
float: c2 = 0.6;
float: c3 = 0.8;
float: c4 = 1.2;

% Capacity / limit bounds (embedded)
int: cap12 = 300;    % X1 + X2 <= 300
int: cap34 = 500;    % X3 + X4 <= 500
int: rhs3  = 100;    % 0.7*X2 - X1 - X3 + 0.9*X4 >= 100
int: rhs4  = 200;    % (X3 - 0.8*X4) - (X1 + X2) <= 200

% Variable upper bounds implied by caps (for bounded vars)
int: ub1 = cap12;
int: ub2 = cap12;
int: ub3 = cap34;
int: ub4 = cap34;

% Variables
var 0..ub1: x1;      % allocation on route X1 (integer, nonnegative)
var 0..ub2: x2;      % allocation on route X2 (integer, nonnegative)
var 0..ub3: x3;      % allocation on route X3 (integer, nonnegative)
var 0..ub4: x4;      % allocation on route X4 (integer, nonnegative)

% Total cost (for objective/reporting)
var float: total_cost;

% Constraints
%-------------------------------
% Capacity constraints (route group limits)
%-------------------------------
constraint x1 + x2 <= cap12;   % X1 + X2 cannot exceed 300
constraint x3 + x4 <= cap34;   % X3 + X4 cannot exceed 500

%-------------------------------
% Regulation constraint 3:
% 0.7*X2 - X1 - X3 + 0.9*X4 >= 100
% Use integer scaling (x10) to avoid float-in-linear-constraint issues.
%-------------------------------
constraint 7 * x2 - 10 * x1 - 10 * x3 + 9 * x4 >= 10 * rhs3;

%-------------------------------
% Regulation constraint 4:
% (X3 - 0.8*X4) - (X1 + X2) <= 200
% Scale by 10 to keep it purely integer.
%-------------------------------
constraint 10 * x3 - 8 * x4 - 10 * x1 - 10 * x2 <= 10 * rhs4;

%-------------------------------
% Total cost definition (for objective/reporting)
%-------------------------------
constraint
  total_cost = c1 * int2float(x1)
             + c2 * int2float(x2)
             + c3 * int2float(x3)
             + c4 * int2float(x4);

% Objective
solve minimize total_cost;

% Optional output (includes rounded objective to 1 decimal place as requested)
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n",
  "total_cost_1dp=", show(round(total_cost * 10.0) / 10.0), "\n"
];