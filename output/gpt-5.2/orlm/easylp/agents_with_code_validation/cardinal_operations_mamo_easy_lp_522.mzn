% Risk coefficients for portfolios X1, X2, X3
array[1..3] of int: risk = [2, 3, 4];

% Return constraint: 5*X1 + 7*X2 + 8*X3 >= 1500
array[1..3] of int: return_coeff = [5, 7, 8];
int: min_return = 1500;

% Difference constraint: X1 - (3/4)*X2 - (1/2)*X3 <= 200
% Multiply by 4: 4*X1 - 3*X2 - 2*X3 <= 800
array[1..3] of int: diff_coeff = [4, -3, -2];
int: max_diff = 800;

% Equality constraint: 2*X2 - X1 - X3 = 400
array[1..3] of int: eq_coeff = [-1, 2, -1];
int: eq_rhs = 400;

% Since bounds are not explicitly provided, assume non-negative investments.
% Use a safe finite upper bound derived from constraints (prevents int_max error).
int: UB = 2000;
array[1..3] of int: lb = [0, 0, 0];
array[1..3] of int: ub = [UB, UB, UB];

% Decision variables (whole-number investments)
array[1..3] of var int: x;  % x[1]=X1, x[2]=X2, x[3]=X3

% Objective variable
var int: total_risk;

% Bounds
constraint forall(i in 1..3) (lb[i] <= x[i] /\ x[i] <= ub[i]);

% Constraints
constraint sum(i in 1..3) (return_coeff[i] * x[i]) >= min_return;
constraint sum(i in 1..3) (diff_coeff[i] * x[i]) <= max_diff;
constraint sum(i in 1..3) (eq_coeff[i] * x[i]) = eq_rhs;

% Total risk
constraint total_risk = sum(i in 1..3) (risk[i] * x[i]);

solve minimize total_risk;

output [
  "X1=", show(x[1]), " X2=", show(x[2]), " X3=", show(x[3]), "\n",
  "total_risk=", show(total_risk), "\n"
];