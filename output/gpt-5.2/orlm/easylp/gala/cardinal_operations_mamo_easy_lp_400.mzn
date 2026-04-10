% Resource allocation / cost minimization for 4 unit types (all integer).
include "globals.mzn";

% ----------------------------
% Data (embedded from statement)
% ----------------------------
int: max12 = 200;          % X1 + X2 <= 200
int: max34 = 150;          % X3 + X4 <= 150

% Strength requirements:
% 5*X1 + 10*X2 >= 1000
int: req12 = 1000;

% 7.5*X3 + 5*X4 >= 750  -> multiply by 2 to avoid fractions:
% 15*X3 + 10*X4 >= 1500
int: req34_scaled = 1500;

% Costs
int: c1 = 5000;
int: c2 = 7000;
int: c3 = 10000;
int: c4 = 3000;

% ----------------------------
% Decision variables
% ----------------------------
var 0..max12: X1;
var 0..max12: X2;
var 0..max34: X3;
var 0..max34: X4;

% ----------------------------
% Constraints
% ----------------------------
constraint X1 + X2 <= max12;
constraint X3 + X4 <= max34;

constraint 5*X1 + 10*X2 >= req12;
constraint 15*X3 + 10*X4 >= req34_scaled;

% ----------------------------
% Objective
% ----------------------------
var int: total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;
solve minimize total_cost;

% ----------------------------
% Output
% ----------------------------
output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), " X4=", show(X4), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];