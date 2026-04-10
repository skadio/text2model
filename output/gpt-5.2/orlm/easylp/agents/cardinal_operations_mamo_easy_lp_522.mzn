% Parameters
% Risk coefficients for portfolios X1, X2, X3
array[1..3] of int: risk = [2, 3, 4];

% Constraint 1 (return): 5*X1 + 7*X2 + 8*X3 >= 1500
array[1..3] of int: return_coeff = [5, 7, 8];
int: min_return = 1500;

% Constraint 2 (difference): X1 - (3/4)X2 - (1/2)X3 <= 200
% Multiply by 4 to keep integer coefficients: 4*X1 - 3*X2 - 2*X3 <= 800
array[1..3] of int: diff_coeff = [4, -3, -2];
int: max_diff_scaled = 800;

% Constraint 3 (equality): 2*X2 - X1 - X3 = 400
array[1..3] of int: eq_coeff = [-1, 2, -1];
int: eq_rhs = 400;

% Investment bounds (not explicitly provided; enforce non-negativity with a large upper bound)
int: lb_invest = 0;
int: ub_invest = 1000000;


% Variables
% Investment amounts in portfolios X1, X2, X3 (whole numbers)
array[1..3] of var int: x;

% Total risk score to minimize
var int: total_risk;


% Constraints
%----------------------------
% Investment bounds (domain constraints)
%----------------------------
constraint
  forall(i in 1..3) (
    x[i] >= lb_invest /\
    x[i] <= ub_invest
  );

%----------------------------
% Return requirement: 5*X1 + 7*X2 + 8*X3 >= 1500
%----------------------------
constraint
  sum(i in 1..3)(return_coeff[i] * x[i]) >= min_return;

%----------------------------
% Difference constraint (scaled to integers): 4*X1 - 3*X2 - 2*X3 <= 800
%----------------------------
constraint
  sum(i in 1..3)(diff_coeff[i] * x[i]) <= max_diff_scaled;

%----------------------------
% Equality constraint: -X1 + 2*X2 - X3 = 400
%----------------------------
constraint
  sum(i in 1..3)(eq_coeff[i] * x[i]) = eq_rhs;

%----------------------------
% Define total risk: 2*X1 + 3*X2 + 4*X3
%----------------------------
constraint
  total_risk = sum(i in 1..3)(risk[i] * x[i]);


% Objective
solve minimize total_risk;