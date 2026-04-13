% Resource allocation between departments X and Y

var int: x; % allocation for department X
var int: y; % allocation for department Y

% Constraints
constraint 5*x + 3*y <= 100;      % budget/resource utilization cap
constraint 2*x + y >= 30;         % service level requirement
constraint abs(x - y) <= 10;      % balance constraint
constraint x >= 0 /\ y >= 0;      % nonnegativity

% Objective: minimize total cost
var int: total_cost = 10*x + 20*y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n",
  "minimum_total_cost_rounded = ", show(total_cost), "\n"
];