% Parameters
int: max_logistics = 50;
int: min_strength = 10;
int: max_diff = 5;

int: cost_x = 10;   % in thousands
int: cost_y = 20;   % in thousands

% Variables
var 0..max_logistics: x;
var 0..max_logistics: y;
var 0..(cost_x*max_logistics + cost_y*max_logistics): total_cost;

% Constraints
constraint 2*x + 3*y <= max_logistics;
constraint 5*x + y >= min_strength;
constraint abs(x - y) <= max_diff;

constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;