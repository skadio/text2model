% Parameters (with values embedded)
int: budget_units = 1000;
int: min_X = 200;
int: min_Y = 150;
int: min_Z = 100;

int: cost_X = 10;
int: cost_Y = 15;
int: cost_Z = 20;

% Variables
var min_X..budget_units: X;  % medical staff investment units (integer)
var min_Y..budget_units: Y;  % facilities investment units (integer)
var min_Z..budget_units: Z;  % technology investment units (integer)

var 0..(cost_X*budget_units + cost_Y*budget_units + cost_Z*budget_units): TotalCost;

% Constraints
constraint X + Y + Z <= budget_units;

constraint TotalCost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize TotalCost;