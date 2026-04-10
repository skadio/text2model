% Parameters
int: x_lb = 0;
int: x_ub = 10;
int: y_lb = 0;
int: y_ub = 8;

int: c_x = 5;
int: c_y = 6;

int: a1_x = 2;
int: a1_y = 3;
int: b1 = 8;

int: a2_x = 4;
int: a2_y = 1;
int: b2 = 16;

% Variables
var x_lb..x_ub: X;
var y_lb..y_ub: Y;
var 0..(c_x * x_ub + c_y * y_ub): TotalCost;

% Constraints
constraint a1_x * X + a1_y * Y >= b1;
constraint a2_x * X + a2_y * Y <= b2;
constraint TotalCost = c_x * X + c_y * Y;

% Objective
solve minimize TotalCost;