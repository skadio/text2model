% Parameters
int: total_limit = 100;
int: min_X = 30;
int: min_Y = 20;
int: min_Z = 10;

int: salary_X = 5000;
int: salary_Y = 4000;
int: salary_Z = 6000;

% Variables
var min_X..total_limit: x;
var min_Y..total_limit: y;
var min_Z..total_limit: z;

var 0..(total_limit * max(salary_X, max(salary_Y, salary_Z))): total_cost;

% Constraints
constraint x + y + z <= total_limit;

constraint total_cost = salary_X * x + salary_Y * y + salary_Z * z;

% Objective
solve minimize total_cost;