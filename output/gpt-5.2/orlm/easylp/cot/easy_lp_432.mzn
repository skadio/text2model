% Parameters (with values embedded)
int: costX = 7;
int: costY = 9;

int: riskA = 4;
int: riskB = 5;
int: riskLimit = 1000;

int: balanceA = 3;
int: balanceB = 2;
int: balanceMin = 200;

int: investLimit = 300;

% Variables
var 0..investLimit: X;
var 0..investLimit: Y;

var 0..(costX*investLimit + costY*investLimit): total_cost;

% Constraints
constraint riskA * X + riskB * Y <= riskLimit;
constraint balanceA * X - balanceB * Y >= balanceMin;
constraint X + Y <= investLimit;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "minimum total cost = ", show(total_cost), "\n"
];