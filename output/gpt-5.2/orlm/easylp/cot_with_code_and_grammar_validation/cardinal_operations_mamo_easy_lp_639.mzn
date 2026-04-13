% Parameters
int: ub_x1 = 20;
int: ub_x2 = 30;
int: ub_x3 = 40;
int: ub_x4 = 50;

int: total_ub = 100;

int: c1 = 200;
int: c2 = 300;
int: c3 = 500;
int: c4 = 1000;

% Variables
var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;
var 0..ub_x4: x4;

% Bounds for scaled linearization (to keep integer coefficients)
var 0..(2*c1*ub_x1 + 2*c2*ub_x2 + 2*c3*ub_x3 + 2*c4*ub_x4): obj2;

% Constraints
constraint x1 + x2 + x3 + x4 <= total_ub;

constraint 10*x1 + 20*x2 >= 50;

constraint 3*x3 - 40*x4 <= 10;

% 15.5*x2 - 0.5*x3 - x1 <= 70
% Multiply by 2: 31*x2 - x3 - 2*x1 <= 140
constraint 31*x2 - x3 - 2*x1 <= 140;

% Objective (minimize total cost; asked "rounded", but costs/integer vars => exact integer)
constraint obj2 = 2*c1*x1 + 2*c2*x2 + 2*c3*x3 + 2*c4*x4;

solve minimize obj2;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_total_cost=", show(obj2 div 2), "\n"
];