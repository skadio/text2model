% Parameters
int: costX = 100;
int: costY = 200;

int: total_funds_max = 50;

int: eff_coeff_X = 3;
int: eff_coeff_Y = -1;
int: eff_min = 10;

int: X_min = 0;
int: X_max = 30;
int: Y_min = 0;
int: Y_max = 20;

% Variables
var X_min..X_max: X;
var Y_min..Y_max: Y;
var 0..(costX*X_max + costY*Y_max): total_cost;

% Constraints
constraint X + Y <= total_funds_max;
constraint eff_coeff_X * X + eff_coeff_Y * Y >= eff_min;
constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;