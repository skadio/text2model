% Parameters (with values embedded)
int: maxA = 1000;
int: maxB = 800;

int: reqA_x1 = 5;
int: reqB_x1 = 4;
int: reqA_x2 = 3;
int: reqB_x2 = 6;
int: reqA_x3 = 8;
int: reqB_x3 = 7;

int: demand = 100;

int: cost_x1 = 10;
int: cost_x2 = 15;
int: cost_x3 = 20;

int: max_x1 = 300;
int: max_x2 = 200;
int: max_x3 = 150;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;

var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3): total_cost;

% Constraints
constraint reqA_x1 * x1 + reqA_x2 * x2 + reqA_x3 * x3 <= maxA;
constraint reqB_x1 * x1 + reqB_x2 * x2 + reqB_x3 * x3 <= maxB;

constraint x1 - 2*x2 + x3 >= demand;

constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Objective
solve minimize total_cost;