% Energy resource allocation between projects X and Y
% Minimize cost: 4*X + 3*Y
% Constraints:
%   X + Y >= 50
%   2*X - Y <= 30
%   X, Y are whole numbers (nonnegative)

include "globals.mzn";

var 0..100000: x;  % allocation to project X
var 0..100000: y;  % allocation to project Y

constraint x + y >= 50;
constraint 2*x - y <= 30;

var 0..1000000: total_cost = 4*x + 3*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_total_cost = ", show(total_cost), "\n"
];