% Parameters
int: min_req = 10;
int: max_cap = 50;
int: sx = 5;
int: sy = 3;

% Variables
var 0..25: X;
var 0..12: Y;
var 0..161: support;

% Constraints
constraint 2 * X + Y >= min_req;
constraint X + 4 * Y <= max_cap;
constraint support = sx * X + sy * Y;

% Objective
solve minimize support;