% Crop planning MILP as an integer optimization problem (data embedded)

% Decision variables: whole-number units of crops X and Y
var 0..100: x;  % units of crop X
var 0..100: y;  % units of crop Y

% Constraints
constraint 5*x + 3*y <= 100;   % water limit
constraint 2*x + y >= 30;      % balanced harvest requirement

% Objective: minimize total cost
var int: cost = 4*x + 2*y;

solve minimize cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_cost = ", show(cost), "\n"
];