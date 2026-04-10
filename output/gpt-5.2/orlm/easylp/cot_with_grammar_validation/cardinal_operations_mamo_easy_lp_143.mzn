% Parameters
int: min_req = 10;
int: max_cap = 50;
int: sup_x = 5;
int: sup_y = 3;

% Variables
var 0..max_cap: X;
var 0..(max_cap div 4): Y;
var 0..(sup_x*max_cap + sup_y*(max_cap div 4)): total_support;

% Constraints
constraint 2*X + Y >= min_req;
constraint X + 4*Y <= max_cap;
constraint total_support = sup_x*X + sup_y*Y;

% Objective
solve minimize total_support;