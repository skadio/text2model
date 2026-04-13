include "globals.mzn";

% Data (embedded as requested)
int: U1 = 100;
int: U2 = 80;
int: U3 = 60;
int: U4 = 50;

% Decision variables: whole-number resource allocations
var 0..U1: x1;
var 0..U2: x2;
var 0..U3: x3;
var 0..U4: x4;

% Constraints
constraint x1 + x2 <= 100;
constraint x2 + x3 >= 50;
constraint x3 - x4 <= 30;
constraint x4 - x3 <= 30; % |x3 - x4| <= 30
constraint 10*x1 + 15*x2 - 5*x3 - 20*x4 >= 150;

% Objective: minimize total cost.
% Scale by 10 to avoid floating-point: 0.5,0.2,0.3,0.4 -> 5,2,3,4
var int: cost10 = 5*x1 + 2*x2 + 3*x3 + 4*x4;

solve minimize cost10;

% "Rounded to nearest whole number" of original units:
% original_cost = cost10 / 10. Nearest integer = floor((cost10 + 5) / 10).
var int: rounded_cost = (cost10 + 5) div 10;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "cost10=", show(cost10), " (i.e., cost=", show(cost10), "/10)\n",
  "rounded_min_cost=", show(rounded_cost), "\n"
];