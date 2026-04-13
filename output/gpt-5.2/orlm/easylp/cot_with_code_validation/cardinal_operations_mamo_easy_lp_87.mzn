% Parameters
int: x_min = 0;
int: x_max = 10;
int: y_min = 0;
int: y_max = 8;

int: c_x = 5;
int: c_y = 6;

int: a1_x = 2;
int: a1_y = 3;
int: b1 = 8;

int: a2_x = 4;
int: a2_y = 1;
int: b2 = 16;

% Variables
var x_min..x_max: X;
var y_min..y_max: Y;
var 0..(c_x * x_max + c_y * y_max): TotalCost;

% Constraints
constraint a1_x * X + a1_y * Y >= b1;
constraint a2_x * X + a2_y * Y <= b2;

constraint TotalCost = c_x * X + c_y * Y;

% Objective
solve minimize TotalCost;