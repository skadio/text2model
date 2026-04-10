% Investment allocation between option X and option Y (integer dollars)

var 0..100000: x; % dollars invested in X
var 0..100000: y; % dollars invested in Y

% Constraints
constraint x + y >= 80;
constraint abs(x - y) <= 10;

% Weighted difference: |0.6x - 0.4y| <= 50
% Multiply by 10 to avoid decimals: |6x - 4y| <= 500
constraint abs(6*x - 4*y) <= 500;

% Objective: minimize total cost
% Cost per unit return: X=$200, Y=$100 (modeled per dollar invested)
var int: total_cost = 200*x + 100*y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];