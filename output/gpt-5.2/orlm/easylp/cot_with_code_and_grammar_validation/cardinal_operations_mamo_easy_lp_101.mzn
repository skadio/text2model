% Parameters
int: salaryX = 5000;
int: salaryY = 8000;
int: maxTotal = 100;
int: minX = 20;
int: minY = 30;

% Variables
var minX..maxTotal: x;
var minY..maxTotal: y;

% Constraints
constraint x + y <= maxTotal;

% Objective
solve minimize salaryX * x + salaryY * y;