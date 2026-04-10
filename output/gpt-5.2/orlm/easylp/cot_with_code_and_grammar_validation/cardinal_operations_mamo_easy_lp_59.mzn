% Parameters
int: min_perf = 10;
int: max_cap = 20;

int: a1 = 3;  % coefficient for X in minimum performance constraint
int: b1 = 1;  % coefficient for Y in minimum performance constraint

int: a2 = 2;  % coefficient for X in maximum capacity constraint
int: b2 = 4;  % coefficient for Y in maximum capacity constraint

int: costX = 4;
int: costY = 6;

% Variables
var 0..ceil(int2float(max_cap) / int2float(a2)): X;
var 0..ceil(int2float(max_cap) / int2float(b2)): Y;

var int: total_cost;

% Constraints
constraint a1 * X + b1 * Y >= min_perf;
constraint a2 * X + b2 * Y <= max_cap;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;