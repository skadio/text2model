include "globals.mzn";

% Resource allocation decision variables (integers)
var 100..800: x1;
var 50..600:  x2;
var 20..400:  x3;
var 40..200:  x4;

% Objective cost coefficients
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Constraints (scaled to avoid decimals)

% 1) 2*x2 - x1 - x3 + x4 >= 1000
constraint 2*x2 - x1 - x3 + x4 >= 1000;

% 2) x1 + x3 <= 0.5*x2 + 0.7*x4 + 500
% Multiply by 10: 10x1 + 10x3 <= 5x2 + 7x4 + 5000
constraint 10*x1 + 10*x3 <= 5*x2 + 7*x4 + 5000;

% 3) 0.8*x1 + x3 - 0.9*x2 <= 1500
% Multiply by 10: 8x1 + 10x3 - 9x2 <= 15000
constraint 8*x1 + 10*x3 - 9*x2 <= 15000;

% 4) x1 + x2 + x3 + x4 >= 200
constraint x1 + x2 + x3 + x4 >= 200;

% 5) (x1 + x3) - (3/5)*x2 <= 300
% Multiply by 5: 5x1 + 5x3 - 3x2 <= 1500
constraint 5*x1 + 5*x3 - 3*x2 <= 1500;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];