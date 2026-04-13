% Construction planning: minimize cost with integer numbers of buildings

% Data (embedded as requested)
int: costX = 50;
int: costY = 70;
int: contribX = 5;
int: contribY = 10;
int: minContribution = 100;
int: maxBuildings = 20;

% Decision variables: number of buildings of each type (whole numbers)
var 0..maxBuildings: x;  % type X
var 0..maxBuildings: y;  % type Y

% Constraints
constraint contribX * x + contribY * y >= minContribution;
constraint x + y <= maxBuildings;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCost = $", show(totalCost), "\n"
];