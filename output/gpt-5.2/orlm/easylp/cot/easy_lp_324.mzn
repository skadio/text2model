% Parameters (with values embedded)
int: budget_max = 500;

int: min_X = 100;
int: min_Y = 50;
int: min_Z = 30;

int: max_X = 300;
int: max_Y = 200;
int: max_Z = 150;

int: cost_X = 100;   % $ per unit (residential)
int: cost_Y = 200;   % $ per unit (commercial)
int: cost_Z = 150;   % $ per unit (industrial)

% Variables
var min_X..max_X: X;
var min_Y..max_Y: Y;
var min_Z..max_Z: Z;

var 0..(cost_X*max_X + cost_Y*max_Y + cost_Z*max_Z): total_cost;

% Constraints
constraint X + Y + Z <= budget_max;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;