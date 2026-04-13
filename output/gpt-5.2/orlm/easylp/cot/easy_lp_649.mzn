% Parameters (with values embedded)
int: n = 4;
set of int: SHIP = 1..n;

array[SHIP] of int: cost = [5, 6, 7, 8];

int: max12 = 1000;
int: max34 = 800;

% Constraints use fractions; scale by LCM(2,4)=4 to keep integer arithmetic:
% x1 - 0.5*x3 >= 200  -> 4*x1 - 2*x3 >= 800
% 0.25*x4 - x2 >= 150 -> x4 - 4*x2 >= 600

% Variables
array[SHIP] of var 0..10000: x; % x[1]=x1, x[2]=x2, x[3]=x3, x[4]=x4 (nonnegative integers)

% Constraints
constraint x[1] + x[2] <= max12;
constraint x[3] + x[4] <= max34;

constraint 4*x[1] - 2*x[3] >= 800;
constraint x[4] - 4*x[2] >= 600;

% Objective
var int: total_cost = sum(i in SHIP)(cost[i] * x[i]);

solve minimize total_cost;