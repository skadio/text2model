% Parameters
int: max_budget = 1000;
int: min_x = 200;
int: min_y = 150;
int: min_z = 50;

int: ret_x = 2;
int: ret_y = 3;
int: ret_z = 1;

% Variables
var min_x..max_budget: x;
var min_y..max_budget: y;
var min_z..max_budget: z;

var 0..max_budget: total_budget;
var 0..(ret_x*max_budget + ret_y*max_budget + ret_z*max_budget): total_return;

% Constraints
constraint total_budget = x + y + z;
constraint total_budget <= max_budget;

constraint total_return = ret_x * x + ret_y * y + ret_z * z;

% Objective
solve minimize total_budget;