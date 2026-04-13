% Parameters (with values embedded)
int: total_cap = 1000;
int: demand_min = 1500;
int: diff_cap = 300;

int: costX = 10;
int: costY = 15;

int: maxX = 700;
int: maxY = 500;

% Variables
var 0..maxX: x;   % units from warehouse X (integer)
var 0..maxY: y;   % units from warehouse Y (integer)

var 0..(costX*maxX + costY*maxY): total_cost;

% Constraints
constraint x + y <= total_cap;
constraint 2*x + 3*y >= demand_min;
constraint abs(x - y) <= diff_cap;

constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;