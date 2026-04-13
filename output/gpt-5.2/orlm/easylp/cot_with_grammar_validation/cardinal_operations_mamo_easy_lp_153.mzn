% Parameters
int: max_total_weight = 40000;
int: min_total_vehicles = 3000;

int: costX = 10;
int: costY = 20;

% NOTE: The problem statement does not specify per-vehicle weight/capacity consumption
% for vehicle types X and Y. To keep the model well-defined, we interpret the only
% weight limitation as applying to the total number of vehicles (1 unit weight each).
int: weightX = 1;
int: weightY = 1;

% Variables
var 0..max_total_weight: x; % number of vehicles of type X
var 0..max_total_weight: y; % number of vehicles of type Y
var 0..(costX*max_total_weight + costY*max_total_weight): total_cost;

% Constraints
constraint x + y >= min_total_vehicles;
constraint weightX * x + weightY * y <= max_total_weight;

constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;