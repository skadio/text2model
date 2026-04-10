% Parameters
int: cost_X = 50;
int: cost_Y = 30;
int: cost_Z = 20;

int: max_total = 500;

int: a1_X = 3;
int: a1_Y = -1;
int: a1_Z = 1;
int: rhs1 = 100;

int: a2_X = 1;
int: a2_Y = -2;
int: a2_Z = -1;
int: rhs2 = 200;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

var 0..(cost_X * max_total + cost_Y * max_total + cost_Z * max_total): total_cost;

% Constraints
constraint X + Y + Z <= max_total;

constraint a1_X * X + a1_Y * Y + a1_Z * Z >= rhs1;

constraint a2_X * X + a2_Y * Y + a2_Z * Z <= rhs2;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;