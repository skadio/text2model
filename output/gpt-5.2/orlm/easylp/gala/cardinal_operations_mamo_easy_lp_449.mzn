include "globals.mzn";

% Data (embedded as requested)
int: costX = 500;
int: costY = 1000;

int: X_lb = 0;
int: X_ub = 7;
int: Y_lb = 0;
int: Y_ub = 5;

int: min_req = 10;   % 5X + 2Y >= 10
int: max_lim = 25;   % 3X + 4Y <= 25

% Decision variables
var X_lb..X_ub: X;
var Y_lb..Y_ub: Y;

% Constraints
constraint 5*X + 2*Y >= min_req;
constraint 3*X + 4*Y <= max_lim;
constraint abs(X - Y) >= 1;

% Objective
var int: totalCost = costX*X + costY*Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = ", show(totalCost), "\n"
];