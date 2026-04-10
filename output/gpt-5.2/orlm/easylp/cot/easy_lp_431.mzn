% Parameters (with values embedded)
int: max_total_trucks = 500;
int: min_trucks_X = 100;
int: min_trucks_Y = 200;
int: cost_X = 10;
int: cost_Y = 20;

% Variables
var 0..max_total_trucks: trucks_X;
var 0..max_total_trucks: trucks_Y;
var 0..(cost_X*max_total_trucks + cost_Y*max_total_trucks): total_cost;

% Constraints
constraint trucks_X >= min_trucks_X;
constraint trucks_Y >= min_trucks_Y;
constraint trucks_X + trucks_Y <= max_total_trucks;

constraint total_cost = cost_X * trucks_X + cost_Y * trucks_Y;

% Objective
solve minimize total_cost;