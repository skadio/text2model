% Parameters
int: max_total_ships = 100;
int: demand_min = 60;
int: balance_max_diff = 30;

int: cost_x = 10;
int: cost_y = 20;

int: max_x = 70;
int: max_y = 50;

% Variables
var 0..max_x: x; % ships on Route X
var 0..max_y: y; % ships on Route Y
var 0..(cost_x*max_x + cost_y*max_y): total_cost;

% Constraints
constraint x + y <= max_total_ships;
constraint 2*x + y >= demand_min;
constraint abs(x - y) <= balance_max_diff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;