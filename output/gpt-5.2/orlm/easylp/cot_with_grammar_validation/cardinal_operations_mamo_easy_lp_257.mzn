% Parameters
int: total_cap = 5000;
int: min_xy = 2000;
int: max_yz = 2500;

int: cx = 50;
int: cy = 30;
int: cz = 20;

% Variables
var 0..total_cap: x;
var 0..total_cap: y;
var 0..total_cap: z;

var 0..(cx*total_cap + cy*total_cap + cz*total_cap): total_cost;

% Constraints
constraint x + y + z <= total_cap;
constraint x + y >= min_xy;
constraint 2*x = y;
constraint y + z <= max_yz;

constraint total_cost = cx*x + cy*y + cz*z;

% Objective
solve minimize total_cost;