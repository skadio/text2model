% Budget allocation for two school projects (integer budgets)

int: minX = 10;
int: minY = 5;
int: maxTotal = 40;

int: outcomeX = 50;
int: outcomeY = 30;

var int: x; % budget for Project X
var int: y; % budget for Project Y

constraint x >= minX;
constraint y >= minY;
constraint x + y <= maxTotal;

var int: total_outcome = outcomeX * x + outcomeY * y;

solve maximize total_outcome;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_budget = ", show(x + y), "\n",
  "optimal_outcome = ", show(total_outcome), "\n",
  "optimal_outcome_rounded_to_nearest_dollar = ", show(total_outcome), "\n"
];