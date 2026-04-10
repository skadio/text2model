% Environmental projects integer optimization (all data embedded)

int: costX = 20;
int: costY = 30;

% Decision variables: whole-number units of each project
var 0..50: x;   % units of project X
var 0..10: y;   % units of project Y (bounded by x + 5y <= 50)

% Constraints
constraint 3*x + y >= 10;     % minimum effectiveness
constraint x + 5*y <= 50;     % budget/manpower limit

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCost = $", show(totalCost), "\n"
];