% Energy optimization: two integer investment decisions X and Y
% Minimize total cost 50*X + 70*Y subject to linear constraints.

int: budget = 500;
int: min_total_invest = 60;
int: diff_limit = 30;

int: costX = 50;
int: costY = 70;

% Decision variables (whole-number investments)
var 0..budget: x;  % investment in Project X
var 0..budget: y;  % investment in Project Y

% Constraints
constraint 5*x + 3*y <= budget;
constraint x + y >= min_total_invest;
constraint x - 2*y <= diff_limit;

% Objective: minimize total investment cost
var int: total_cost = costX*x + costY*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];