% Supply chain resource allocation (all data embedded)

var 0..1000: x1;
var 0..1000: x2;
var 0..1200: x3;
var 0..1200: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint x3 + x4 <= 1200;

% 0.7*x1 - 0.8*x2 >= 200  -> multiply by 10 to keep integer coefficients:
constraint 7*x1 - 8*x2 >= 2000;

constraint x4 - x3 >= 300;

% Objective: minimize total cost
% 1.5*x1 + 2*x2 + 3*x3 + 4*x4 -> multiply by 2 to avoid fractions:
var int: cost2 = 3*x1 + 4*x2 + 6*x3 + 8*x4;
solve minimize cost2;

% Output minimum total cost rounded down
% floor((cost2)/2) is correct since floor( (3*x1+4*x2+6*x3+8*x4)/2 )
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_cost_floor=", show(cost2 div 2), "\n",
  "cost2=", show(cost2), "\n"
];