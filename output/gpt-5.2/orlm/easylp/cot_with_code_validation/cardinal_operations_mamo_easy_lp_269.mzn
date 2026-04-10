% Parameters
int: max_total_hires = 100;
int: minX = 20;
int: minY = 30;
int: minZ = 10;

int: salX = 50000;
int: salY = 70000;
int: salZ = 90000;

% Variables
var minX..max_total_hires: X;
var minY..max_total_hires: Y;
var minZ..max_total_hires: Z;

var 0..(max_total_hires * max([salX, salY, salZ])): total_cost;

% Constraints
constraint X + Y + Z <= max_total_hires;

constraint total_cost = salX * X + salY * Y + salZ * Z;

% Objective
solve minimize total_cost;