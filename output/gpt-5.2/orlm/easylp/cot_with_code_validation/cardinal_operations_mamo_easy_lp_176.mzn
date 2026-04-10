% Parameters
int: cX = 10;
int: cY = 15;
int: cZ = 20;

int: x_lb = 0;
int: x_ub = 2000;
int: y_lb = 0;
int: y_ub = 1500;
int: z_lb = 0;
int: z_ub = 2500;

int: XY_ub = 5000;
int: YZ_lb = 3000;
int: XZ_ub = 4000;

% Variables
var x_lb..x_ub: X;
var y_lb..y_ub: Y;
var z_lb..z_ub: Z;

var 0..(cX*x_ub + cY*y_ub + cZ*z_ub): total_cost;

% Constraints
constraint X + Y <= XY_ub;
constraint Y + Z >= YZ_lb;
constraint X + Z <= XZ_ub;

constraint total_cost = cX * X + cY * Y + cZ * Z;

% Objective
solve minimize total_cost;