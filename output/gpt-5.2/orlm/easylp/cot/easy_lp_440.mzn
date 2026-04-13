% Parameters (with values embedded)
int: budgetLimit = 100;
int: serviceMin = 30;
int: balanceLimit = 10;

int: utilX = 5;
int: utilY = 3;

int: serviceX = 2;
int: serviceY = 1;

int: costX = 10;
int: costY = 20;

% Variables
var 0..budgetLimit: x;  % allocation to department X
var 0..budgetLimit: y;  % allocation to department Y

var 0..(costX*budgetLimit + costY*budgetLimit): totalCost;

% Constraints
constraint utilX * x + utilY * y <= budgetLimit;
constraint serviceX * x + serviceY * y >= serviceMin;
constraint abs(x - y) <= balanceLimit;

constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(totalCost), "\n"
];