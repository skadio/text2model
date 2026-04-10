% Parameters
int: costX = 4;
int: costY = 5;

int: max_weighted_total = 100;   % X + 3Y <= 100
int: min_requirement = 50;       % 2X + Y >= 50
int: max_diff = 20;              % |X - Y| <= 20

int: maxX = 60;
int: maxY = 30;

% Variables
var 0..maxX: x;
var 0..maxY: y;

var 0..(costX*maxX + costY*maxY): total_cost;

% Constraints
constraint x + 3*y <= max_weighted_total;
constraint 2*x + y >= min_requirement;
constraint abs(x - y) <= max_diff;

constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;