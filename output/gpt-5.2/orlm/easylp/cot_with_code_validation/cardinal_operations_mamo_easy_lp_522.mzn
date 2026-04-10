% Investment portfolio optimization (all-integer)
% Data (embedded)
int: risk1 = 2;
int: risk2 = 3;
int: risk3 = 4;

int: ret1 = 5;
int: ret2 = 7;
int: ret3 = 8;
int: min_return = 1500;

int: rhs_eq = 400;

% Missing in original: finite bounds are required; otherwise the search space is unbounded
% Use safe, sufficiently large bounds derived from constraints:
% From 2*X2 - X1 - X3 = 400 and nonnegativity, X2 >= 200.
% For minimization with positive risks, we can cap variables without excluding optima.
int: UB = 5000;

% Decision variables (whole-number investments)
var 0..UB: X1;
var 0..UB: X2;
var 0..UB: X3;

% Constraints
constraint ret1*X1 + ret2*X2 + ret3*X3 >= min_return;

% X1 - 3/4 X2 - 1/2 X3 <= 200  ->  4*X1 - 3*X2 - 2*X3 <= 800
constraint 4*X1 - 3*X2 - 2*X3 <= 800;

% 2*X2 - X1 - X3 = 400
constraint 2*X2 - X1 - X3 = rhs_eq;

% Objective: minimize total risk
var int: total_risk = risk1*X1 + risk2*X2 + risk3*X3;

solve minimize total_risk;

output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), "\n",
  "total_risk=", show(total_risk), "\n"
];