int: max_budget = 10000;

% Decision variables: integer budgets in dollars
var 0..max_budget: x; % budget for project X
var 0..max_budget: y; % budget for project Y

% Constraints
constraint x + y <= max_budget;

% Mission requirement: combined impact score at least 40000
% as stated: 10*x + 4*y >= 40000
constraint 10 * x + 4 * y >= 40000;

% Objective: minimize total cost (total dollars allocated)
solve minimize x + y;

output [
  "Minimum total cost (dollars) = ", show(x + y), "\n",
  "x = ", show(x), "\n",
  "y = ", show(y), "\n"
];