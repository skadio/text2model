% Supply chain resource allocation (all data embedded)

% Decision variables (integer, nonnegative)
var 0..599: x1; % manufacturing: less than 600
var 0..500: x2; % distribution: at most 500
var 0..299: x3; % retail: less than 300

% Constraints
constraint x1 + x2 + x3 <= 1000;

% 5*x1 - 0.5*x2 >= 500  -> multiply by 2 to keep integer arithmetic:
constraint 10*x1 - x2 >= 1000;

% 4.5*x3 - x1 <= 450 -> multiply by 2:
constraint 9*x3 - 2*x1 <= 900;

% x2 + 0.5*x3 - x1 >= 200 -> multiply by 2:
constraint 2*x2 + x3 - 2*x1 >= 400;

% Objective: minimize total cost 2*x1 + 3*x2 + 4*x3
var int: total_cost = 2*x1 + 3*x2 + 4*x3;
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];