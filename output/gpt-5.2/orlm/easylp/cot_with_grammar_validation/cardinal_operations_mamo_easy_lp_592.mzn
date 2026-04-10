% Parameters
int: max_X1X2 = 300;
int: max_X3X4 = 500;

int: rhs_weighted = 100;
int: rhs_other = 200;

% Costs as scaled integers (x10) to avoid floats
int: c1 = 5;   % 0.5 * 10
int: c2 = 6;   % 0.6 * 10
int: c3 = 8;   % 0.8 * 10
int: c4 = 12;  % 1.2 * 10

% Coefficients as scaled integers (x10) to avoid floats
int: a2 = 7;   % 0.7 * 10
int: a4 = 9;   % 0.9 * 10
int: b4 = 8;   % 0.8 * 10

% Variables
var 0..max_X1X2: X1;
var 0..max_X1X2: X2;
var 0..max_X3X4: X3;
var 0..max_X3X4: X4;

var 0..(c1*max_X1X2 + c2*max_X1X2 + c3*max_X3X4 + c4*max_X3X4): total_cost_x10;

% Constraints
constraint X1 + X2 <= max_X1X2;
constraint X3 + X4 <= max_X3X4;

% 0.7*X2 - X1 - X3 + 0.9*X4 >= 100
% Multiply by 10: 7*X2 - 10*X1 - 10*X3 + 9*X4 >= 1000
constraint a2*X2 - 10*X1 - 10*X3 + a4*X4 >= rhs_weighted * 10;

% (X3 - 0.8*X4) - (X1 + X2) <= 200
% Multiply by 10: 10*X3 - 8*X4 - 10*X1 - 10*X2 <= 2000
constraint 10*X3 - b4*X4 - 10*X1 - 10*X2 <= rhs_other * 10;

constraint total_cost_x10 = c1*X1 + c2*X2 + c3*X3 + c4*X4;

% Objective
solve minimize total_cost_x10;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "min_total_cost=", show(total_cost_x10 div 10), ".", show(total_cost_x10 mod 10), "\n"
];