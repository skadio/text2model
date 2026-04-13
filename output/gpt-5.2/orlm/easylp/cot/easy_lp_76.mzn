% Parameters (with values embedded)
int: maxTotalProjects = 50;
int: minDiversity = 30;          % 2*X + Y >= 30
int: maxDifference = 10;         % |X - Y| <= 10
int: maxX = 40;
int: maxY = 20;
int: costX = 2000;
int: costY = 3000;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..(costX*maxX + costY*maxY): totalCost;

% Constraints
constraint X + Y <= maxTotalProjects;
constraint 2*X + Y >= minDiversity;
constraint abs(X - Y) <= maxDifference;
constraint totalCost = costX*X + costY*Y;

% Objective
solve minimize totalCost;

output [
  "Minimum total cost ($): ", show(totalCost), "\n",
  "X projects: ", show(X), "\n",
  "Y projects: ", show(Y), "\n"
];