% Parameters
int: availA = 1000;
int: availB = 800;

int: reqA1 = 5;
int: reqB1 = 4;
int: reqA2 = 3;
int: reqB2 = 6;
int: reqA3 = 8;
int: reqB3 = 7;

int: demand = 100;

int: cost1 = 10;
int: cost2 = 15;
int: cost3 = 20;

int: max1 = 300;
int: max2 = 200;
int: max3 = 150;

% Variables
var 0..max1: x1;
var 0..max2: x2;
var 0..max3: x3;

var 0..(cost1*max1 + cost2*max2 + cost3*max3): total_cost;

% Constraints
constraint reqA1*x1 + reqA2*x2 + reqA3*x3 <= availA;
constraint reqB1*x1 + reqB2*x2 + reqB3*x3 <= availB;

constraint x1 - 2*x2 + x3 >= demand;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3;

% Objective
solve minimize total_cost;