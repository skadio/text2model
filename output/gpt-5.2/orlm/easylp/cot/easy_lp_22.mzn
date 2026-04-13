% Parameters (with values embedded)
int: costX = 50;
int: costY = 60;

int: cap = 500;          % x + 2y <= 500
int: demand = 200;       % 3x + y >= 200
int: balance = 100;      % |x - y| <= 100

% Variables
var 0..500: x;   % units of product X (integer)
var 0..250: y;   % units of product Y (integer), from x+2y<=500 and x>=0

% Constraints
constraint x + 2*y <= cap;
constraint 3*x + y >= demand;
constraint abs(x - y) <= balance;

% Objective
var int: total_cost = costX * x + costY * y;
solve minimize total_cost;