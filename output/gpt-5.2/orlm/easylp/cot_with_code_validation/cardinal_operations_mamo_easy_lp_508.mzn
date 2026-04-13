% Parameters
int: budget = 1000;
int: cX = 2;
int: cY = 3;
int: cZ = 4;

int: a1 = 5;   % coefficient for X in constraint 1
int: b1 = -2;  % coefficient for Y in constraint 1
int: rhs1 = 200;

int: diffZY_max = 300;  % Z - Y <= 300
int: x_ge_z_plus = 50;  % X >= Z + 50

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;

var 0..(cX*budget + cY*budget + cZ*budget): total_cost;

% Constraints
constraint X + Y + Z <= budget;

constraint a1 * X + b1 * Y >= rhs1;

constraint Z - Y <= diffZY_max;

constraint X >= Z + x_ge_z_plus;

% Objective
constraint total_cost = cX * X + cY * Y + cZ * Z;

solve minimize total_cost;