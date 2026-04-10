% Military logistics resource allocation (integer linear optimization)

% Data (embedded as requested)
int: max_total_units = 1000;

int: min_strength = 500;      % requirement: 2*X + 1*Y >= 500
int: x_coeff = 2;
int: y_coeff = 1;

int: x_support = 500;         % support points per unit of X
int: y_support = 300;         % support points per unit of Y

int: x_lb = 0;
int: x_ub = 700;
int: y_lb = 0;
int: y_ub = 400;

% Decision variables (integers)
var x_lb..x_ub: X;
var y_lb..y_ub: Y;

% Constraints
constraint X + Y <= max_total_units;
constraint x_coeff * X + y_coeff * Y >= min_strength;

% Objective: minimize total support points
var int: total_support = x_support * X + y_support * Y;
solve minimize total_support;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalSupport = ", show(total_support), "\n"
];