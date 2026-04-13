% Parameters (with values embedded)
int: total_capacity = 100;

int: cost_X = 1000;
int: cost_Y = 2000;
int: cost_Z = 3000;

int: min_2X_plus_Y = 30;
int: min_X_plus_Z = 40;

int: lb_X = 0; int: ub_X = 50;
int: lb_Y = 0; int: ub_Y = 60;
int: lb_Z = 0; int: ub_Z = 70;

% Variables
var lb_X..ub_X: X;
var lb_Y..ub_Y: Y;
var lb_Z..ub_Z: Z;

var 0..(cost_X*ub_X + cost_Y*ub_Y + cost_Z*ub_Z): total_cost;

% Constraints
constraint X + Y + Z <= total_capacity;
constraint 2*X + Y >= min_2X_plus_Y;
constraint X + Z >= min_X_plus_Z;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;