% Parameters (with values embedded)
int: max_total_production = 500;

int: demand_xy_min = 200;          % 2*X + Y >= 200
int: demand_yz_min = 150;          % Y + Z >= 150

int: costX = 50;
int: costY = 60;
int: costZ = 20;

int: X_min = 0; int: X_max = 300;
int: Y_min = 0; int: Y_max = 200;
int: Z_min = 0; int: Z_max = 100;

% Variables
var X_min..X_max: X;
var Y_min..Y_max: Y;
var Z_min..Z_max: Z;

var 0..(costX*X_max + costY*Y_max + costZ*Z_max): total_cost;

% Constraints
constraint X + Y + Z <= max_total_production;
constraint 2*X + Y >= demand_xy_min;
constraint Y + Z >= demand_yz_min;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;