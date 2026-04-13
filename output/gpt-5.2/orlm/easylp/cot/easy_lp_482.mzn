% Parameters (with values embedded)
int: minX = 10;
int: minY = 5;
int: totalBudgetMax = 40;
int: outcomePerX = 50;
int: outcomePerY = 30;

% Variables
var minX..totalBudgetMax: X;
var minY..totalBudgetMax: Y;
var 0..(outcomePerX*totalBudgetMax + outcomePerY*totalBudgetMax): totalOutcome;

% Constraints
constraint X + Y <= totalBudgetMax;
constraint totalOutcome = outcomePerX * X + outcomePerY * Y;

% Objective
solve maximize totalOutcome;