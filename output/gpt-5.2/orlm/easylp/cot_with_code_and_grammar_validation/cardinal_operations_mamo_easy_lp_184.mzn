% Parameters
int: capacity = 1000;

int: demand_X_coeff = 3;
int: demand_Y_coeff = 4;
int: demand_min = 600;

int: balance_Z_coeff = 5;
int: balance_Y_coeff = 1;
int: balance_max = 200;

int: cost_X = 50;
int: cost_Y = 30;
int: cost_Z = 20;

% Variables
var 0..capacity: X;
var 0..capacity: Y;
var 0..capacity: Z;

var 0..(cost_X*capacity + cost_Y*capacity + cost_Z*capacity): total_cost;

% Constraints
constraint X + Y + Z <= capacity;

constraint demand_X_coeff * X + demand_Y_coeff * Y >= demand_min;

constraint abs(balance_Z_coeff * Z - balance_Y_coeff * Y) <= balance_max;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;