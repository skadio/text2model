% Parameters
int: x_min = 0;
int: x_max = 10;
int: y_min = 0;
int: y_max = 8;

int: a1 = 2;
int: b1 = 3;
int: c1 = 8;

int: a2 = 4;
int: b2 = 1;
int: c2 = 16;

int: cost_x = 5;
int: cost_y = 6;

% Variables
var x_min..x_max: X;
var y_min..y_max: Y;
var 0..(cost_x * x_max + cost_y * y_max): TotalCost;

% Constraints
constraint a1 * X + b1 * Y >= c1;
constraint a2 * X + b2 * Y <= c2;
constraint TotalCost = cost_x * X + cost_y * Y;

% Objective
solve minimize TotalCost;