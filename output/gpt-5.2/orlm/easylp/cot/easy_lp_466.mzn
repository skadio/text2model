% Parameters (with values embedded)
int: salaryX = 5000;
int: salaryY = 3000;
int: maxTotalHires = 50;
int: minX = 20;
int: maxY = 15;

% Variables
var 0..maxTotalHires: X;
var 0..maxTotalHires: Y;
var 0..(salaryX*maxTotalHires + salaryY*maxTotalHires): totalCost;

% Constraints
constraint X >= minX;
constraint Y <= maxY;
constraint X + Y <= maxTotalHires;

constraint totalCost = salaryX * X + salaryY * Y;

% Objective
solve minimize totalCost;