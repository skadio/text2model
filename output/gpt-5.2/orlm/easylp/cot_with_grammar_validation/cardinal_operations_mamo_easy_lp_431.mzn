% Parameters
int: max_total_trucks = 500;
int: min_trucks_x = 100;
int: min_trucks_y = 200;
int: cost_x = 10;
int: cost_y = 20;

% Variables
var min_trucks_x..max_total_trucks: trucks_x;
var min_trucks_y..max_total_trucks: trucks_y;
var 0..(max_total_trucks * max(cost_x, cost_y)): total_cost;

% Constraints
constraint trucks_x + trucks_y <= max_total_trucks;
constraint total_cost = cost_x * trucks_x + cost_y * trucks_y;

% Objective
solve minimize total_cost;