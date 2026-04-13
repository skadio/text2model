% Parameters
int: cap4 = 60;
int: cap3 = 40;
int: pol4 = 30;
int: pol3 = 15;

int: demand = 1000;
int: pol_max = 430;

% Variables
var 0..(demand div cap4 + 1): x4; % number of 4-wheelers
var 0..(demand div cap3 + 1): x3; % number of 3-wheelers
var 0..(demand div min(cap3,cap4) + 2): total;

% Constraints
constraint cap4 * x4 + cap3 * x3 >= demand;
constraint pol4 * x4 + pol3 * x3 <= pol_max;
constraint total = x4 + x3;

% Objective
solve minimize total;