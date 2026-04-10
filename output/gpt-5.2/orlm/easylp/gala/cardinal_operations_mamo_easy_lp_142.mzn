% Military resource allocation (integer linear optimization)

% Data (embedded as required)
int: max_logistics = 50;      % 3*X + 2*Y <= 50
int: min_strength  = 10;      % X + Y >= 10
int: support_x = 4;           % support points per unit of X
int: support_y = 5;           % support points per unit of Y

% Decision variables (whole numbers)
var 0..max_logistics: X;
var 0..max_logistics: Y;

% Constraints
constraint 3*X + 2*Y <= max_logistics;
constraint X + Y >= min_strength;

% Objective: minimize total support points
var 0..(support_x*max_logistics + support_y*max_logistics): total_support;
constraint total_support = support_x*X + support_y*Y;

solve minimize total_support;

% Output: minimum total support points (already an integer, so rounding is unchanged)
output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total support points (rounded) = ", show(total_support), "\n"
];