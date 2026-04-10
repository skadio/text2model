% Budget allocation across four online marketing channels
% Variables: x1, x2, x3, x4 (integer allocations)

int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Upper bounds (not specified numerically in the description, so use the natural one implied by x1+x2<=1000)
int: UB = 1000;

var 0..UB: x1;
var 0..UB: x2;
var 0..UB: x3;
var 0..UB: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint x2 + x3 >= 500;

% x3 - 0.5*x4 <= 200  ->  2*x3 - x4 <= 400
constraint 2*x3 - x4 <= 400;

% x1 >= 0.7*x4  ->  10*x1 >= 7*x4
constraint 10*x1 >= 7*x4;

% 0.8*x2 + x3 - x1 <= 70  ->  4*x2 + 5*x3 - 5*x1 <= 350
constraint 4*x2 + 5*x3 - 5*x1 <= 350;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];