% Parameters
int: capacity = 500;

int: min_X = 0;
int: max_X = 300;
int: min_Y = 0;
int: max_Y = 200;
int: min_Z = 0;
int: max_Z = 100;

int: req_2X_plus_Y = 200;
int: req_Y_plus_Z = 150;

int: cost_X = 50;
int: cost_Y = 60;
int: cost_Z = 20;

% Variables
var min_X..max_X: X;
var min_Y..max_Y: Y;
var min_Z..max_Z: Z;

var 0..(cost_X*max_X + cost_Y*max_Y + cost_Z*max_Z): total_cost;

% Constraints
constraint X + Y + Z <= capacity;

constraint 2*X + Y >= req_2X_plus_Y;

constraint Y + Z >= req_Y_plus_Z;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;