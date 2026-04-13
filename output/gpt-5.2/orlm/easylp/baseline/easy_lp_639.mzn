% University budget allocation - embedded data, integer variables

int: UB1 = 20;
int: UB2 = 30;
int: UB3 = 40;
int: UB4 = 50;

var 0..UB1: x1;
var 0..UB2: x2;
var 0..UB3: x3;
var 0..UB4: x4;

% Objective: minimize total cost (in dollars)
var int: total_cost = 200*x1 + 300*x2 + 500*x3 + 1000*x4;

constraint x1 + x2 + x3 + x4 <= 100;

% 10*x1 + 20*x2 >= 50
constraint 10*x1 + 20*x2 >= 50;

% 3*x3 should not exceed 40*x4 by more than 10: 3*x3 - 40*x4 <= 10
constraint 3*x3 - 40*x4 <= 10;

% 15.5*x2 - 0.5*x3 - x1 <= 70
% Multiply by 2 to keep it integral: 31*x2 - x3 - 2*x1 <= 140
constraint 31*x2 - x3 - 2*x1 <= 140;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_total_cost_rounded=", show(total_cost), "\n"
];