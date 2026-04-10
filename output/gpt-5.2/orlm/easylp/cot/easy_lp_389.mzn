% Parameters (with values embedded)
int: n = 4;
array[1..n] of int: cost = [100, 200, 300, 400];

int: max12 = 500;
int: max34 = 600;
int: min13 = 300;
int: min24 = 400;

int: ub12 = 500; % upper bound for x1, x2
int: ub34 = 600; % upper bound for x3, x4

% Variables
var 0..ub12: x1;
var 0..ub12: x2;
var 0..ub34: x3;
var 0..ub34: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;
constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;

% Objective
solve minimize total_cost;