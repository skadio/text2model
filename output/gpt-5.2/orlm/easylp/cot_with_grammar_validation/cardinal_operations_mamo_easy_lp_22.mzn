% Parameters
int: costX = 50;
int: costY = 60;

int: cap = 500;
int: dem = 200;
int: diffMax = 100;

% Variables
var 0..cap: x;
var 0..cap: y;

var 0..(costX*cap + costY*cap): total_cost;

% Constraints
constraint x + 2*y <= cap;
constraint 3*x + y >= dem;
constraint abs(x - y) <= diffMax;

constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;